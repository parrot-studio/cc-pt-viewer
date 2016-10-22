class ArcanaSearcher
  QUERY_CONDITION_NAMES = [
    :recently, :job, :rarity, :weapon, :actor, :illustrator,
    :union, :source, :sourcecategory, :skill, :skillcost,
    :skillsub, :skilleffect, :abilitycategory, :abilityeffect, :abilitycondition,
    :chainabilitycategory, :chainabilityeffect, :chainabilitycondition,
    :arcanacost, :chaincost, :actorname, :illustratorname, :name
  ].freeze

  CONVERT_TABLE = {
    job: :job_type,
    weapon: :weapon_type,
    arcanacost: :cost,
    chaincost: :chain_cost,
    sourcecategory: :source_category,
    actor: :voice_actor_id,
    illustrator: :illustrator_id
  }.freeze

  REVERSE_CONVERT_TABLE = lambda do
    ret = {}
    CONVERT_TABLE.each do |k, v|
      ret[v] = k
    end
    ret
  end.call.freeze

  QUERY_KEYS = lambda do
    QUERY_CONDITION_NAMES.map { |n| CONVERT_TABLE[n] ? CONVERT_TABLE[n] : n }
  end.call.freeze

  DETAIL_COND_LIST = [
    :job_type, :rarity, :cost, :chain_cost, :union, :weapon_type,
    :skill, :skillcost, :abilitycategory, :chainabilitycategory,
    :source_category, :voice_actor_id, :illustrator_id
  ].freeze

  class << self
    def parse(params)
      as = self.new
      as.parse(params)
      as
    end
  end

  def parse(params)
    @query_key = nil
    @query_string = nil
    @query_detail = nil
    @query = parse_params(params)
    @query
  end

  def empty?
    @query.blank? ? true : false
  end

  def query_key
    return '' if empty?
    @query_key ||= Digest::MD5.hexdigest(query_string)
    @query_key
  end

  def query_string
    return '' if empty?
    @query_string ||= create_query_string(@query)
    @query_string
  end

  def query_detail
    return '' if empty?
    @query_detail ||= create_query_detail(@query)
    @query_detail
  end

  def search
    return [] if empty?
    @result = if @query[:recently]
      re = @query[:recently].to_i
      re = ServerSettings.recently if re < 1
      ArcanaCache.recently(re)
    else
      ArcanaCache.search_result(query_key) do
        arcana_search_from_query(@query)
      end
    end
    @result
  end

  def result
    @result || []
  end

  private

  def condition_name(n)
    return if n.blank?
    name = CONVERT_TABLE[n]
    name ? name : n
  end

  def query_name(n)
    return if n.blank?
    name = REVERSE_CONVERT_TABLE[n]
    name ? name : n
  end

  def parse_params(org)
    return if org.blank?

    query = {}
    QUERY_CONDITION_NAMES.each do |n|
      val = org[n]
      next unless val
      name = condition_name(n)

      case name
      when :rarity
        rarity = case val
        when /\A(\d)U\z/
          r = Regexp.last_match(1).to_i
          Arcana::RARITYS.include?(r) ? (r..(Arcana::RARITYS.max)) : nil
        when /\A\d\z/
          r = val.to_i
          Arcana::RARITYS.include?(r) ? r : nil
        end
        query[name] = rarity unless rarity.blank?
      when :skillcost
        cost = case val
        when /\A(\d)D\z/
          r = Regexp.last_match(1).to_i
          Skill::COSTS.include?(r) ? (1..r) : nil
        when /\A\d\z/
          r = val.to_i
          Skill::COSTS.include?(r) ? r : nil
        end
        query[name] = cost unless cost.blank?
      when :job_type
        job = [val].flatten.uniq.compact.map(&:upcase).select { |j| Arcana::JOB_TYPES.include?(j) }
        query[name] = job.first unless job.blank?
      when :weapon_type
        weapon = [val].flatten.uniq.compact.select { |j| Arcana::WEAPON_TYPES.include?(j) }
        query[name] = weapon.first unless weapon.blank?
      when :actorname
        aid = ArcanaCache.voice_actor_id(val)
        next unless aid
        query[:voice_actor_id] = aid
      when :illustratorname
        iid = ArcanaCache.illustrator_id(val)
        next unless iid
        query[:illustrator_id] = iid
      else
        v = case val
        when /\A(\d+)D\z/
          (0..(Regexp.last_match(1).to_i))
        when /\A\d+\z/
          val.to_i
        else
          val
        end
        next if v.blank?
        query[name] = v
      end
    end

    query
  end

  def each_querys(query)
    QUERY_KEYS.each do |k|
      q = query[k]
      next unless q
      yield(k, q)
    end
  end

  def create_query_string(query)
    return '' if query.blank?
    return '' if query[:recently]

    ret = {}
    each_querys(query) do |k, q|
      case k
      when :rarity
        v = case q
        when Range
          "#{q.first}U"
        else
          q
        end
        ret[query_name(k)] = v
      when :voice_actor_id
        name = ArcanaCache.voice_actor_name(q)
        next unless name
        ret[:actorname] = name
      when :illustrator_id
        name = ArcanaCache.illustrator_name(q)
        next unless name
        ret[:illustratorname] = name
      else
        v = case q
        when Range
          "#{q.last}D"
        else
          q
        end
        ret[query_name(k)] = v
      end
    end
    ret.to_query
  end

  def create_query_detail(query)
    return '' if query.blank?
    return "最新 #{query[:recently]}件" if query[:recently]
    return "名前 - #{query[:name]}" if query[:name]

    skill = false
    list = DETAIL_COND_LIST.map do |k|
      q = query[k]
      next unless q
      case k
      when :job_type
        Arcana::JOB_NAMES[q.to_sym]
      when :weapon_type
        "武器 - #{Arcana::WEAPON_NAMES[q.to_sym]}"
      when :union
        "所属 - #{Arcana::UNION_NAMES[q.to_sym]}"
      when :voice_actor_id
        "声優 - #{ArcanaCache.voice_actor_name(q)}"
      when :illustrator_id
        "イラスト - #{ArcanaCache.illustrator_name(q)}"
      when :rarity
        case q
        when Range
          "★#{q.first}以上"
        else
          "★#{q}"
        end
      when :cost
        str = 'コスト'
        str += case q
        when Range
          "#{q.last}以下"
        else
          q.to_s
        end
        str
      when :chain_cost
        str = '絆コスト'
        str += case q
        when Range
          "#{q.last}以下"
        else
          q.to_s
        end
        str
      when :skill, :skillcost
        next if skill
        str = 'スキル - '
        str += SkillEffect::CATEGORYS.fetch(query[:skill].to_sym, {}).fetch(:name, '') if query[:skill]
        if query[:skillcost]
          str += ' マナ'
          str += case query[:skillcost]
          when Range
            "#{query[:skillcost].last}以下"
          else
            query[:skillcost].to_s
          end
        end
        if query[:skillsub] || query[:skilleffect]
          table = SkillEffect::CATEGORYS.fetch(query[:skill].to_sym, {})
          next if table.blank?
          ss = []
          ss << table.fetch(:sub, {}).fetch(query[:skillsub].to_sym, nil) if query[:skillsub]
          ss << table.fetch(:effect, {}).fetch(query[:skilleffect].to_sym, nil) if query[:skilleffect]
          text = ss.compact.join(' + ')
          str += "（#{text}）" unless text.blank?
        end
        skill = true
        str
      when :abilitycategory
        table = AbilityEffect::CATEGORYS.fetch(query[:abilitycategory].to_sym, {})
        next if table.blank?
        str = 'アビリティ - '
        str += table.fetch(:name, '') unless (query[:abilitycondition] && query[:abilityeffect])
        str += (' ' + AbilityEffect::CONDITIONS.fetch(query[:abilitycondition].to_sym, '')) if query[:abilitycondition]
        str += (' ' + table.fetch(:effect, {}).fetch(query[:abilityeffect].to_sym, '')) if query[:abilityeffect]
        str
      when :chainabilitycategory
        table = AbilityEffect::CATEGORYS.fetch(query[:chainabilitycategory].to_sym, {})
        next if table.blank?
        str = '絆アビリティ - '
        str += table.fetch(:name, '') unless (query[:chainabilitycondition] && query[:chainabilityeffect])
        str += (' ' + AbilityEffect::CONDITIONS.fetch(query[:chainabilitycondition].to_sym, '')) if query[:chainabilitycondition]
        str += (' ' + table.fetch(:effect, {}).fetch(query[:chainabilityeffect].to_sym, '')) if query[:chainabilityeffect]
        str
      when :source_category
        table = Arcana::SOURCE_TABLE.fetch(query[:source_category].to_sym, {})
        next if table.blank?
        str = '入手先 - '
        str += table.fetch(:name, '')
        str += (' ' + table.fetch(:details, {}).fetch(query[:source].to_sym, '')) if query[:source]
        str
      end
    end
    list.reject(&:blank?).join(' / ')
  end

  def arcana_search_from_query(org)
    return [] if org.blank?

    query = org.dup
    skill = query.delete(:skill)
    skillcost = query.delete(:skillcost)
    skillsub = query.delete(:skillsub)
    skilleffect = query.delete(:skilleffect)
    abcate = query.delete(:abilitycategory)
    abeffect = query.delete(:abilityeffect)
    abcond = query.delete(:abilitycondition)
    cabcate = query.delete(:chainabilitycategory)
    cabeffect = query.delete(:chainabilityeffect)
    cabcond = query.delete(:chainabilitycondition)

    query = replace_source_query(query)

    arel = Arcana.all

    unless skill.blank? && skillcost.blank?
      skills = skill_search(skill, skillcost, skillsub, skilleffect)
      return [] if skills.blank?
      arel = arel.where(first_skill_id: skills)
                 .or(Arcana.where(second_skill_id: skills))
                 .or(Arcana.where(third_skill_id: skills))
    end

    unless (abcate.blank? && abeffect.blank? && abcond.blank?)
      abs = ability_search(abcate, abeffect, abcond)
      return [] if abs.blank?
      arel = arel.where(first_ability_id: abs)
                 .or(Arcana.where(second_ability_id: abs))
                 .or(Arcana.where(weapon_ability_id: abs))
    end

    unless (cabcate.blank? && cabeffect.blank? && cabcond.blank?)
      abs = chain_ability_search(cabcate, cabeffect, cabcond)
      return [] if abs.blank?
      arel = arel.where(chain_ability_id: abs)
    end

    arel = arel.where(query)

    table = Arcana.arel_table
    arel.order(
      table[:rarity].desc, table[:cost].desc,
      table[:job_type].asc, table[:job_index].desc
    ).distinct.pluck(:job_code)
  end

  def skill_search(category, cost, sub, ef)
    return [] if (category.blank? && cost.blank?)

    arel = SkillEffect.all
    unless ef.blank?
      efs = [ef].flatten.uniq.compact
      arel = arel.where(subeffect1: efs)
                 .or(SkillEffect.where(subeffect2: efs))
                 .or(SkillEffect.where(subeffect3: efs))
                 .or(SkillEffect.where(subeffect4: efs))
                 .or(SkillEffect.where(subeffect5: efs))
    end

    arel = arel.where(category: category) unless category.blank?
    arel = arel.where(subcategory: sub) unless sub.blank?
    arel = arel.joins(:skill).where(skills: { cost: cost }) unless cost.blank?
    arel.pluck(:skill_id)
  end

  def ability_search(cate, effect, cond)
    return [] if (cate.blank? && effect.blank? && cond.blank?)
    efs = effect_group_for(effect)

    es = AbilityEffect.all
    es = es.where(category: cate) unless cate.blank?
    es = es.where(effect: efs) unless efs.blank?
    es = es.where(condition: cond) unless cond.blank?
    es.pluck(:ability_id).uniq
  end

  def chain_ability_search(cate, effect, cond)
    return [] if (cate.blank? && effect.blank?)
    efs = effect_group_for(effect)

    es = ChainAbilityEffect.all
    es = es.where(category: cate) unless cate.blank?
    es = es.where(effect: efs) unless efs.blank?
    es = es.where(condition: cond) unless cond.blank?
    es.pluck(:chain_ability_id).uniq
  end

  def effect_group_for(ef)
    return if ef.blank?
    group = AbilityEffect::EFFECT_GROUP[ef.to_sym]
    return ef if group.blank?
    [ef, group].flatten.uniq.compact
  end

  def replace_source_query(q)
    return q if q[:source_category].blank?
    return q unless Arcana::SOURCE_GROUP_CATEGORYS.include?(q[:source_category].to_sym)
    cate = q.delete(:source_category)
    return q if q[:source].present?
    ss = Arcana::SOURCE_TABLE.fetch(cate.to_sym, {}).fetch(:details, {}).keys
    return q if ss.blank?
    q[:source] = ss
    q
  end
end

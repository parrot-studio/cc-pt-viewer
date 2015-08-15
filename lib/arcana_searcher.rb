class ArcanaSearcher

  QUERY_CONDITION_NAMES = [
    :recently, :job, :rarity, :weapon, :actor, :illustrator,
    :union, :source, :sourcecategory, :skill, :skillcost,
    :skillsub, :skilleffect, :abilitycategory, :abilityeffect,
    :chainabilitycategory, :chainabilityeffect, :arcanacost, :chaincost,
    :actorname, :illustratorname
  ].freeze

  KEY_TABLE = {
    recently: 're',
    job_type: 'jt',
    rarity: 'ra',
    weapon_type: 'wt',
    cost: 'co',
    chain_cost: 'ch',
    union: 'un',
    source: 'so',
    source_category: 'soc',
    voice_actor_id: 'an',
    illustrator_id: 'in',
    skill: 'sk',
    skillcost: 'skc',
    skillsub: 'sks',
    skilleffect: 'ske',
    abilitycategory: 'abca',
    abilityeffect: 'abe',
    chainabilitycategory: 'caca',
    chainabilityeffect: 'cae'
  }

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

  DETAIL_COND_LIST = [
    :job_type, :rarity, :cost, :chain_cost, :union, :weapon_type,
    :skill, :skillcost, :abilitycategory, :chainabilitycategory,
    :source_category, :voice_actor_id, :illustrator_id
  ]

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
    @query_key ||= create_query_key(@query)
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
      re = ServerSettings.recently.to_i if re < 1
      Arcana.order('id DESC').limit(re)
    else
      arcana_search_from_query(@query)
    end
    result
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
        actor = VoiceActor.find_by(name: val)
        next unless actor
        query[:voice_actor_id] = actor.id
      when :illustratorname
        illust = Illustrator.find_by(name: val)
        next unless illust
        query[:illustrator_id] = illust.id
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
    KEY_TABLE.keys.each do |k|
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
        actor = VoiceActor.find_by(id: q)
        next unless actor
        ret[:actorname] = actor.name
      when :illustrator_id
        illust = Illustrator.find_by(id: q)
        next unless illust
        ret[:illustratorname] = illust.name
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

  def create_query_key(query)
    return if query.blank?
    return "#{KEY_TABLE[:recently]}:#{query[:recently]}" if query[:recently]

    keys = []
    each_querys(query) do |k, q|
      ke = case k
      when :voice_actor_id
        actor = VoiceActor.find_by(id: q)
        next unless actor
        "#{KEY_TABLE[k]}:#{actor.name}"
      when :illustrator_id
        illust = Illustrator.find_by(id: q)
        next unless illust
        "#{KEY_TABLE[k]}:#{illust.name}"
      else
        val = case q
        when Range
          "#{q.first}-#{q.last}"
        else
          q
        end
        "#{KEY_TABLE[k]}:#{val}"
      end
      keys << ke
    end
    keys.join(',')
  end

  def create_query_detail(query)
    return '' if query.blank?
    return "最新 #{query[:recently]}件" if query[:recently]

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
        actor = VoiceActor.find_by(id: q)
        "声優 - #{actor ? actor.name : nil}"
      when :illustrator_id
        illust = Illustrator.find_by(id: q)
        "イラスト - #{illust ? illust.name : nil}"
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
        str += table.fetch(:name, '')
        str += (' ' + table.fetch(:effect, {}).fetch(query[:abilityeffect].to_sym, '')) if query[:abilityeffect]
        str
      when :chainabilitycategory
        table = AbilityEffect::CATEGORYS.fetch(query[:chainabilitycategory].to_sym, {})
        next if table.blank?
        str = '絆アビリティ - '
        str += table.fetch(:name, '')
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
    cabcate = query.delete(:chainabilitycategory)
    cabeffect = query.delete(:chainabilityeffect)

    arel = Arcana.where(query)

    unless skill.blank? && skillcost.blank?
      skills = skill_search(skill, skillcost, skillsub, skilleffect)
      return [] if skills.blank?
      arel.where!(skill_id: skills)
    end

    unless (abcate.blank? && abeffect.blank?)
      abs = ability_search(abcate, abeffect)
      return [] if abs.blank?
      arel.where!(Arcana.where(first_ability_id: abs).where(second_ability_id: abs).where_values.reduce(:or))
    end

    unless (cabcate.blank? && cabeffect.blank?)
      abs = chain_ability_search(cabcate, cabeffect)
      return [] if abs.blank?
      arel.where!(chain_ability_id: abs)
    end

    arel.order(
      'arcanas.rarity DESC, arcanas.cost DESC, arcanas.job_type, arcanas.job_index DESC'
    )
  end

  def skill_search(category, cost, sub, ef)
    return [] if (category.blank? && cost.blank?)

    arel = SkillEffect.all
    arel.where!(category: category) unless category.blank?
    arel.where!(subcategory: sub) unless sub.blank?
    arel = arel.joins(:skill).where(skills: { cost: cost }) unless cost.blank?
    unless ef.blank?
      efs = [ef].flatten.uniq.compact
      arel.where!(
        SkillEffect.where(
          subeffect1: efs
        ).where(
          subeffect2: efs
        ).where(
          subeffect3: efs
        ).where(
          subeffect4: efs
        ).where(
          subeffect5: efs
        ).where_values.reduce(:or)
      )
    end

    arel.pluck(:skill_id)
  end

  def ability_search(cate, effect)
    return [] if (cate.blank? && effect.blank?)

    es = AbilityEffect.all
    es.where!(category: cate) unless cate.blank?
    es.where!(effect: effect) unless effect.blank?
    es.pluck(:ability_id).uniq
  end

  def chain_ability_search(cate, effect)
    return [] if (cate.blank? && effect.blank?)

    es = ChainAbilityEffect.all
    es.where!(category: cate) unless cate.blank?
    es.where!(effect: effect) unless effect.blank?
    es.pluck(:chain_ability_id).uniq
  end

end

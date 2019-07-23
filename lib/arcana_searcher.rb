# rubocop:disable Metrics/PerceivedComplexity, Metrics/AbcSize
# rubocop:disable Metrics/CyclomaticComplexity, Metrics/LineLength
# rubocop:disable Metrics/BlockLength, Metrics/MethodLength, Metrics/ClassLength
class ArcanaSearcher
  QUERY_CONDITION_NAMES = %i[
    recently job rarity weapon arcanatype actor illustrator
    union source sourcecategory skill skillcost
    skillsub skilleffect skillinheritable
    abilitycategory abilityeffect abilitycondition abilitytarget
    abilitysubeffect abilitysubcondition abilitysubtarget
    chainabilitycategory chainabilityeffect
    chainabilitycondition chainabilitytarget
    arcanacost chaincost actorname illustratorname name
  ].freeze

  CONVERT_TABLE = {
    job: :job_type,
    weapon: :weapon_type,
    arcanacost: :cost,
    chaincost: :chain_cost,
    sourcecategory: :source_category,
    arcanatype: :arcana_type,
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
    QUERY_CONDITION_NAMES.map { |n| CONVERT_TABLE[n] || n }
  end.call.freeze

  DETAIL_COND_LIST = %i[
    job_type rarity cost chain_cost union weapon_type arcana_type
    skill skillcost abilitycategory chainabilitycategory
    source_category voice_actor_id illustrator_id
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

    @result =
      if @query[:recently]
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
    name || n
  end

  def query_name(n)
    return if n.blank?

    name = REVERSE_CONVERT_TABLE[n]
    name || n
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
        query[name] = rarity if rarity.present?
      when :skillcost
        cost = case val
        when /\A(\d)D\z/
          r = Regexp.last_match(1).to_i
          Skill::COSTS.include?(r) ? (1..r) : nil
        when /\A\d\z/
          r = val.to_i
          Skill::COSTS.include?(r) ? r : nil
        end
        query[name] = cost if cost.present?
      when :job_type
        job = [val].flatten.uniq.compact.map(&:upcase).select { |j| Arcana::JOB_TYPES.include?(j) }
        query[name] = job.first if job.present?
      when :weapon_type
        weapon = [val].flatten.uniq.compact.select { |j| Arcana::WEAPON_TYPES.include?(j) }
        query[name] = weapon.first if weapon.present?
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
      when :arcana_type
        "タイプ - #{Arcana::ARCANA_TYPE_NAMES[q.to_sym]}"
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
      when :skill
        str = 'スキル - '
        str += SkillEffect::CATEGORYS.fetch(query[:skill].to_sym, {}).fetch(:name, '') if query[:skill]

        if query[:skillcost] || query[:skillsub] || query[:skilleffect] || query[:skillinheritable]
          table = SkillEffect::CATEGORYS.fetch(query[:skill].to_sym, {})
          next if table.blank?

          ss = []

          ss <<
            case query[:skillcost]
            when nil, ''
              nil
            when Range
              "マナ#{query[:skillcost].last}以下"
            else
              "マナ#{query[:skillcost]}"
            end

          ss << table.fetch(:sub, {}).fetch(query[:skillsub].to_sym, nil) if query[:skillsub]
          ss << table.fetch(:effect, {}).fetch(query[:skilleffect].to_sym, nil) if query[:skilleffect]
          ss << '伝授のみ' if query[:skillinheritable]
          text = ss.compact.join(' + ')
          str += "（#{text}）" if text.present?
        end
        str
      when :abilitycategory
        create_query_detail_for_ability(query)
      when :chainabilitycategory
        table = AbilityEffect::CATEGORYS.fetch(query[:chainabilitycategory].to_sym, {})
        next if table.blank?

        str = '絆アビリティ - '
        str += table.fetch(:name, '') unless (query[:chainabilitycondition] && query[:chainabilityeffect])
        str += (' ' + AbilityEffect::CONDITIONS.fetch(query[:chainabilitycondition].to_sym, '')) if query[:chainabilitycondition]
        str += (' ' + table.fetch(:effect, {}).fetch(query[:chainabilityeffect].to_sym, '')) if query[:chainabilityeffect]
        str += (' ' + table.fetch(:target, {}).fetch(query[:chainabilitytarget].to_sym, '')) if query[:chainabilitytarget]
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

  def create_query_detail_for_ability(query)
    table = AbilityEffect::CATEGORYS.fetch(query[:abilitycategory].to_sym, {})
    return if table.blank?

    str = 'アビリティ - '
    str += table.fetch(:name, '') unless (query[:abilitycondition] && query[:abilityeffect])

    if query[:abilitycondition]
      str += (' ' + AbilityEffect::CONDITIONS.fetch(query[:abilitycondition].to_sym, ''))
      if query[:abilitysubcondition]
        sname = table.fetch(:sub_condition, {})
                     .fetch(query[:abilitycondition].to_sym, {})
                     .fetch(query[:abilitysubcondition].to_sym, '')
        str += "(#{sname})" if sname.present?
      end
    end

    if query[:abilityeffect]
      str += (' ' + table.fetch(:effect, {}).fetch(query[:abilityeffect].to_sym, ''))
      if query[:abilitysubeffect]
        sname = table.fetch(:sub_effect, {})
                     .fetch(query[:abilityeffect].to_sym, {})
                     .fetch(query[:abilitysubeffect].to_sym, '')
        str += "/#{sname}" if sname.present?
      end
    end

    if query[:abilitytarget]
      str += (' ' + table.fetch(:target, {}).fetch(query[:abilitytarget].to_sym, ''))
      if query[:abilitysubtarget]
        sname = table.fetch(:sub_target, {})
                     .fetch(query[:abilitytarget].to_sym, {})
                     .fetch(query[:abilitysubtarget].to_sym, '')
        str += "/#{sname}" if sname.present?
      end
    end

    str
  end

  def arcana_search_from_query(org)
    return [] if org.blank?

    query = org.dup

    squery = {
      category: query.delete(:skill),
      cost: query.delete(:skillcost),
      sub: query.delete(:skillsub),
      effect: query.delete(:skilleffect),
      inheritable: query.delete(:skillinheritable)
    }.reject { |_, v| v.blank? }

    aquery = {
      category: query.delete(:abilitycategory),
      effect: query.delete(:abilityeffect),
      subeffect: query.delete(:abilitysubeffect),
      condition: query.delete(:abilitycondition),
      subcondition: query.delete(:abilitysubcondition),
      target: query.delete(:abilitytarget),
      subtarget: query.delete(:abilitysubtarget)
    }.reject { |_, v| v.blank? }

    cquery = {
      category: query.delete(:chainabilitycategory),
      effect: query.delete(:chainabilityeffect),
      condition: query.delete(:chainabilitycondition),
      target: query.delete(:chainabilitytarget)
    }.reject { |_, v| v.blank? }

    query = replace_source_query(query)

    arel = Arcana.all

    if squery.present?
      ids = skill_search(squery)
      return [] if ids.blank?

      arel = arel.where(id: ids)
    end

    if aquery.present?
      ids = ability_search(Ability.normal_abilities, aquery)
      return [] if ids.blank?

      arel = arel.where(id: ids)
    end

    if cquery.present?
      ids = ability_search(Ability.chain_abilities, cquery)
      return [] if ids.blank?

      arel = arel.where(id: ids)
    end

    arel = arel.where(query)

    table = Arcana.arel_table
    arel.order(
      table[:rarity].desc, table[:cost].desc,
      table[:job_type].asc, table[:job_index].desc
    ).distinct.pluck(:job_code)
  end

  def skill_search(squery)
    return [] if squery.blank?

    sk = Skill.all
    sk = sk.where(cost: squery[:cost]) if squery[:cost].present?
    sk = sk.inheritable_only if squery[:inheritable].present?

    if squery[:category].present? || squery[:sub].present? || squery[:effect].present?
      arel = SkillEffect.all
      if squery[:effect].present?
        efs = [squery[:effect]].flatten.map { |e| skill_effect_group_for(e) }.uniq.compact
        arel = arel.where(subeffect1: efs)
                   .or(SkillEffect.where(subeffect2: efs))
                   .or(SkillEffect.where(subeffect3: efs))
                   .or(SkillEffect.where(subeffect4: efs))
                   .or(SkillEffect.where(subeffect5: efs))
      end
      arel = arel.where(category: squery[:category]) if squery[:category].present?
      arel = arel.where(subcategory: squery[:sub]) if squery[:sub].present?
      sk = sk.joins(:skill_effects).merge(arel)
    end

    sk.distinct.pluck(:arcana_id)
  end

  def ability_search(base, query)
    return [] unless base
    return [] if query.blank?

    efs = ability_effect_group_for(query[:effect])
    ts = target_group_for(query[:target])

    arel = AbilityEffect.all
    arel = arel.where(category: query[:category]) if query[:category].present?
    arel = arel.where(effect: efs) if efs.present?
    arel = arel.where(condition: query[:condition]) if query[:condition].present?
    arel = arel.where(target: ts) if ts.present?
    arel = arel.where(sub_effect: query[:subeffect]) if query[:subeffect].present?
    arel = arel.where(sub_condition: query[:subcondition]) if query[:subcondition].present?
    arel = arel.where(sub_target: query[:subtarget]) if query[:subtarget].present?

    base.joins(:ability_effects).merge(arel).distinct.pluck(:arcana_id)
  end

  def skill_effect_group_for(ef)
    return if ef.blank?

    group = SkillEffect::EFFECT_GROUP[ef.to_sym]
    return ef if group.blank?

    [ef, group].flatten.uniq.compact
  end

  def ability_effect_group_for(ef)
    return if ef.blank?

    group = AbilityEffect::EFFECT_GROUP[ef.to_sym]
    efs = [ef, group].flatten.uniq.compact

    efs.map do |e|
      AbilityEffect::BUFF_TYPES.include?(e) ? [e, "#{e}_m"] : e
    end.flatten.uniq.compact
  end

  def target_group_for(t)
    return if t.blank?

    group = AbilityEffect::TARGET_GROUP[t.to_sym]
    return t if group.blank?

    [t, group].flatten.uniq.compact
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
# rubocop:enable Metrics/PerceivedComplexity, Metrics/AbcSize
# rubocop:enable Metrics/CyclomaticComplexity, Metrics/LineLength
# rubocop:enable Metrics/BlockLength, Metrics/MethodLength, Metrics/ClassLength

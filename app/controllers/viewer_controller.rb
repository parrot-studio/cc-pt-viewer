class ViewerController < ApplicationController

  def index
    code = params[:code]
    @ptm = (!code.blank? && parse_pt_code(code)) ? code : ''
    @actors = VoiceActor.order('count DESC, name')
    @illusts = Illustrator.order(:name)
  end

  def arcanas
    as = search_arcanas
    render json: (as || [])
  end

  def ptm
    ret = search_members(params[:ptm])
    render json: (ret || {})
  end

  def codes
    as = specified_arcanas(params[:codes])
    render json: (as || [])
  end

  def about
  end

  def changelogs
  end

  private

  def parse_pt_code(code)
    part = "([#{Arcana::JOB_TYPES.join}]\\d+|N)"
    parser = /\A(V\d+)#{part * 7}\z/
    m = code.upcase.match(parser)
    return unless m

    selector = lambda {|c| c == 'N' ? nil : c}
    {
      mem1: selector.call(m[2]),
      mem2: selector.call(m[3]),
      mem3: selector.call(m[4]),
      mem4: selector.call(m[5]),
      sub1: selector.call(m[6]),
      sub2: selector.call(m[7]),
      friend: selector.call(m[8])
    }
  end

  def query_params
    params.permit(:recently, :job, :rarity, :weapon, :actor, :illustrator,
      :union, :source, :sourcecategory,:addition, :skill, :skillcost,
      :skillsub, :skilleffect, :abilitycond, :abilityeffect,
      :chainabilitycond, :chainabilityeffect)
  end

  def recently_arcanas
    with_cache('arcanas_recently') do
      Arcana.order('id DESC').limit(ServerSettings.recently.to_i).map(&:serialize)
    end
  end

  def search_arcanas
    org = query_params
    return [] if org.blank?
    return recently_arcanas if org[:recently]

    query = build_query(org)
    return [] if query.empty?

    qkey = query.delete(:cache_key)
    with_cache(qkey) do
      arcana_search_from_query(query).map(&:serialize)
    end
  end

  def search_members(ptm)
    return {} if ptm.blank?
    mems = parse_pt_code(ptm)
    return {} unless mems

    cs = mems.values.uniq.compact
    return {} if cs.empty?
    as = Arcana.where(:job_code => cs).index_by(&:job_code)

    ret = {}
    mems.each do |po, co|
      a = as[co]
      next unless a
      ret[po] = as[co].serialize
    end
    ret
  end

  def specified_arcanas(codes)
    return [] if codes.blank?
    cs = codes.split('/')
    return [] if cs.blank?
    Arcana.where(:job_code => cs).map(&:serialize)
  end

  def build_query(org)
    return if org.blank?

    rarity = lambda do |q|
      case q
      when /\A(\d)U\z/
        r = $1.to_i
        Arcana::RARITYS.include?(r) ? (r..(Arcana::RARITYS.max)) : nil
      when /\A\d\z/
        r = q.to_i
        Arcana::RARITYS.include?(r) ? [r] : nil
      else
        nil
      end
    end.call(org[:rarity])

    skillcost = lambda do |q|
      case q
      when /\A(\d)D\z/
        r = $1.to_i
        Skill::COSTS.include?(r) ? (1..r) : nil
      when /\A\d\z/
        r = q.to_i
        Skill::COSTS.include?(r) ? [r] : nil
      else
        nil
      end
    end.call(org[:skillcost])

    job = [org[:job]].flatten.uniq.compact.select{|j| j.upcase!; Arcana::JOB_TYPES.include?(j)}
    weapon = [org[:weapon]].flatten.uniq.compact.select{|j| Arcana::WEAPON_TYPES.include?(j)}

    union = [org[:union]].flatten.uniq.compact
    sourcecategory = [org[:sourcecategory]].flatten.uniq.compact
    source = [org[:source]].flatten.uniq.compact
    actor = [org[:actor]].flatten.uniq.compact
    illust = [org[:illustrator]].flatten.uniq.compact
    skill = [org[:skill]].flatten.uniq.compact
    skillsub = [org[:skillsub]].flatten.uniq.compact
    skilleffect = [org[:skilleffect]].flatten.uniq.compact
    abilitycond = [org[:abilitycond]].flatten.uniq.compact
    abilityeffect = [org[:abilityeffect]].flatten.uniq.compact
    chainabilitycond = [org[:chainabilitycond]].flatten.uniq.compact
    chainabilityeffect = [org[:chainabilityeffect]].flatten.uniq.compact

    compact = lambda do |cond|
      cond.size == 1 ? cond.first : cond
    end

    query = {}
    query[:job_type] = compact.call(job) unless job.blank?
    query[:rarity] = compact.call(rarity) unless rarity.blank?
    query[:weapon_type] = compact.call(weapon) unless weapon.blank?
    query[:union] = compact.call(union) unless union.blank?
    query[:source_category] = compact.call(sourcecategory) unless sourcecategory.blank?
    query[:source] = compact.call(source) unless source.blank?
    query[:voice_actor_id] = compact.call(actor) unless actor.blank?
    query[:illustrator_id] = compact.call(illust) unless illust.blank?
    query[:skill] = compact.call(skill) unless skill.blank?
    query[:skillcost] = compact.call(skillcost) unless skillcost.blank?
    query[:skillsub] = compact.call(skillsub) unless skillsub.blank?
    query[:skilleffect] = compact.call(skilleffect) unless skilleffect.blank?
    query[:abilitycond] = compact.call(abilitycond) unless abilitycond.blank?
    query[:abilityeffect] = compact.call(abilityeffect) unless abilityeffect.blank?
    query[:chainabilitycond] = compact.call(chainabilitycond) unless chainabilitycond.blank?
    query[:chainabilityeffect] = compact.call(chainabilityeffect) unless chainabilityeffect.blank?

    key = "arcanas"
    key += "_j:#{job.sort.join}" if query[:job_type]
    key += "_r:#{rarity.to_a.join}" if query[:rarity]
    key += "_w:#{weapon.sort.join}" if query[:weapon_type]
    key += "_u:#{union.sort.join('/')}" if query[:union]
    key += "_soc:#{sourcecategory.sort.join('/')}" if query[:source_category]
    key += "_so:#{source.sort.join('/')}" if query[:source]
    key += "_a:#{actor.sort.join('/')}" if query[:voice_actor_id]
    key += "_i:#{illust.sort.join('/')}" if query[:illustrator_id]
    key += "_sk:#{skill.sort.join('|')}" if query[:skill]
    key += "_skco:#{skillcost.to_a.join('|')}" if query[:skillcost]
    key += "_sksub:#{skillsub.sort.join('|')}" if query[:skillsub]
    key += "_skef:#{skilleffect.sort.join('|')}" if query[:skilleffect]
    key += "_abc:#{abilitycond.sort.join('/')}" if query[:abilitycond]
    key += "_abe:#{abilityeffect.sort.join('/')}" if query[:abilityeffect]
    key += "_cabc:#{chainabilitycond.sort.join('/')}" if query[:chainabilitycond]
    key += "_cabe:#{chainabilityeffect.sort.join('/')}" if query[:chainabilityeffect]

    query[:cache_key] = key
    query
  end

  def arcana_search_from_query(query)
    return [] if query.blank?

    skill = query.delete(:skill)
    skillcost = query.delete(:skillcost)
    skillsub = query.delete(:skillsub)
    skilleffect = query.delete(:skilleffect)
    abcond = query.delete(:abilitycond)
    abeffect = query.delete(:abilityeffect)
    cabcond = query.delete(:chainabilitycond)
    cabeffect = query.delete(:chainabilityeffect)

    arel = Arcana.where(query)

    unless (skill.blank? && skillcost.blank?)
      skills = skill_search(skill, skillcost, skillsub, skilleffect)
      return [] if skills.blank?
      arel.where!(:skill_id => skills)
    end

    unless (abcond.blank? && abeffect.blank?)
      abs = ability_search(abcond, abeffect)
      return [] if abs.blank?
      arel.where!(Arcana.where(:first_ability_id => abs).where(:second_ability_id => abs).where_values.reduce(:or))
    end

    unless (cabcond.blank? && cabeffect.blank?)
      abs = chain_ability_search(cabcond, cabeffect)
      return [] if abs.blank?
      arel.where!(:chain_ability_id => abs)
    end

    arel.order(
      'arcanas.job_type, arcanas.rarity DESC, arcanas.cost DESC, arcanas.job_index DESC'
    )
  end

  def skill_search(category, cost, sub, ef)
    return [] if (category.blank? && cost.blank?)
    arel = Skill.all
    arel.where!(:category => category) unless category.blank?
    arel.where!(:cost => cost) unless cost.blank?
    arel.where!(:subcategory => sub) unless sub.blank?
    unless ef.blank?
      arel.where!(Skill.where(:subeffect1 => ef).where(:subeffect2 => ef).where_values.reduce(:or))
    end
    arel.pluck(:id)
  end

  def ability_search(cond, effect)
    return [] if (cond.blank? && effect.blank?)

    es = AbilityEffect.all
    es.where!(:condition_type => cond) unless cond.blank?
    es.where!(:effect_type => effect) unless effect.blank?
    es.map(&:abilities).flatten.map(&:id).uniq
  end

  def chain_ability_search(cond, effect)
    return [] if (cond.blank? && effect.blank?)

    es = ChainAbilityEffect.all
    es.where!(:condition_type => cond) unless cond.blank?
    es.where!(:effect_type => effect) unless effect.blank?
    es.map(&:chain_abilities).flatten.map(&:id).uniq
  end

  def with_cache(name, &b)
    return unless (name && b)
    return b.call unless ServerSettings.cache

    data = Rails.cache.read(name)
    return data if data

    ret = b.call
    return unless ret
    Rails.cache.write(name, ret)

    ret
  end

end

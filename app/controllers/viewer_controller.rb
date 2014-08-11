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

  def about
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
    params.permit([:job, :rarity, :weapon, :recently,:actor, :illustrator,
        :growth, :source, :addition, :skill, :skillsub, :abiritycond, :abirityeffect])
  end

  def recently_arcanas
    cache_name = 'arcanas_recently'
    as = Rails.cache.read(cache_name)
    if as.blank?
      as = Arcana.order('id DESC').limit(ServerSettings.recently.to_i).map(&:serialize)
      Rails.cache.write(cache_name, as.to_a)
    end
    as
  end

  def search_arcanas
    org = query_params
    return [] if org.blank?
    return recently_arcanas if org[:recently]

    query = build_query(org)
    return [] if query.empty?

    qkey = query.delete(:cache_key)
    as = Rails.cache.read(qkey)
    unless as
      skill = query.delete(:skill)
      skillsub = query.delete(:skillsub)
      abcond = query.delete(:abiritycond)
      abeffect = query.delete(:abirityeffect)

      arel = Arcana.where(query)

      skills = skill_search(skill, skillsub)
      arel.where!(:skill_id => skills) unless skills.blank?

      abs = ability_search(abcond, abeffect)
      unless abs.blank?
        arel.where!(Arcana.where(:first_ability_id => abs).where(:second_ability_id => abs).where_values.reduce(:or))
      end

      as = arel.order(
        'arcanas.job_type, arcanas.rarity DESC, arcanas.cost DESC, arcanas.job_index DESC'
      ).map(&:serialize)
      Rails.cache.write(qkey, as)
    end
    as
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

    job = [org[:job]].flatten.uniq.compact.select{|j| j.upcase!; Arcana::JOB_TYPES.include?(j)}
    weapon = [org[:weapon]].flatten.uniq.compact.select{|j| Arcana::WEAPON_TYPES.include?(j)}
    growth = [org[:growth]].flatten.uniq.compact.select{|g| g.downcase!; Arcana::GROWTH_TYPES.include?(g)}
    source = [org[:source]].flatten.uniq.compact.select{|s| s.downcase!; Arcana::SOURCE_NAMES.include?(s)}

    actor = [org[:actor]].flatten.uniq.compact
    illust = [org[:illustrator]].flatten.uniq.compact
    ex2 = true unless org[:addition].blank?
    skill = [org[:skill]].flatten.uniq.compact
    skillsub = [org[:skillsub]].flatten.uniq.compact
    abiritycond = [org[:abiritycond]].flatten.uniq.compact
    abirityeffect = [org[:abirityeffect]].flatten.uniq.compact

    compact = lambda do |cond|
      cond.size == 1 ? cond.first : cond
    end

    query = {}
    query[:job_type] = compact.call(job) unless job.blank?
    query[:rarity] = compact.call(rarity) unless rarity.blank?
    query[:weapon_type] = compact.call(weapon) unless weapon.blank?
    query[:growth_type] = compact.call(growth) unless growth.blank?
    query[:source] = compact.call(source) unless source.blank?
    query[:voice_actor_id] = compact.call(actor) unless actor.blank?
    query[:illustrator_id] = compact.call(illust) unless illust.blank?
    query[:addition] = '1' if ex2
    query[:skill] = compact.call(skill) unless skill.blank?
    query[:skillsub] = compact.call(skillsub) unless skillsub.blank?
    query[:abiritycond] = compact.call(abiritycond) unless abiritycond.blank?
    query[:abirityeffect] = compact.call(abirityeffect) unless abirityeffect.blank?

    key = "arcanas"
    key += "_j:#{job.sort.join}" if query[:job_type]
    key += "_r:#{rarity.to_a.join}" if query[:rarity]
    key += "_w:#{weapon.sort.join}" if query[:weapon_type]
    key += "_g:#{growth.sort.join('/')}" if query[:growth_type]
    key += "_s:#{source.sort.join('/')}" if query[:source]
    key += "_a:#{actor.sort.join('/')}" if query[:voice_actor_id]
    key += "_i:#{illust.sort.join('/')}" if query[:illustrator_id]
    key += "_sk:#{skill.sort.join('|')}" if query[:skill]
    key += "_subsk:#{skillsub.sort.join('|')}" if query[:skillsub]
    key += "_ex2" if ex2
    key += "_abc:#{abiritycond.sort.join('/')}" if query[:abiritycond]
    key += "_abe:#{abirityeffect.sort.join('/')}" if query[:abirityeffect]

    query[:cache_key] = key
    query
  end

  def skill_search(category, sub)
    return [] if category.blank?
    arel = Skill.where(:category => category)
    arel.where!(:subcategory => sub) unless sub.blank?
    arel.pluck(:id)
  end

  def ability_search(cond, effect)
    return [] if (cond.blank? && effect.blank?)
    arel = Ability.all
    arel.where!(:condition_type => cond) unless cond.blank?
    arel.where!(:effect_type => effect) unless effect.blank?
    arel.pluck(:id)
  end

end

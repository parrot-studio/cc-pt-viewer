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
    params.permit([:job, :rarity, :weapon, :recently,
        :actor, :illustrator, :growth, :source])
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
      as = Arcana.where(query).order('job_type, rarity DESC, cost DESC, job_index DESC').map(&:serialize)
      Rails.cache.write(qkey, as.to_a)
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
    weapon = [org[:weapon]].flatten.uniq.compact.select{|j| j.upcase!; Arcana::WEAPON_TYPES.include?(j)}
    growth = [org[:growth]].flatten.uniq.compact.select{|g| g.downcase!; Arcana::GROWTH_TYPES.include?(g)}
    source = [org[:source]].flatten.uniq.compact.select{|s| s.downcase!; Arcana::SOURCE_NAMES.include?(s)}

    actor = [org[:actor]].flatten.uniq.compact
    illust = [org[:illustrator]].flatten.uniq.compact

    query = {}
    query[:job_type] = (job.size == 1 ? job.first : job) unless job.blank?
    query[:rarity] = (rarity.size == 1 ? rarity.first : rarity) unless rarity.blank?
    query[:weapon_type] = (weapon.size == 1 ? weapon.first : weapon) unless weapon.blank?
    query[:growth_type] = (growth.size == 1 ? growth.first : growth) unless growth.blank?
    query[:source] = (source.size == 1 ? source.first : source) unless source.blank?
    query[:voice_actor_id] = (actor.size == 1 ? actor.first : actor) unless actor.blank?
    query[:illustrator_id] = (illust.size == 1 ? illust.first : actor) unless illust.blank?

    key = "arcanas"
    key += "_j:#{job.sort.join}" if query[:job_type]
    key += "_r:#{rarity.to_a.join}" if query[:rarity]
    key += "_w:#{weapon.sort.join}" if query[:weapon_type]
    key += "_g:#{growth.sort.join('/')}" if query[:growth_type]
    key += "_s:#{source.sort.join('/')}" if query[:source]
    key += "_a:#{actor.sort.join('/')}" if query[:voice_actor_id]
    key += "_i:#{illust.sort.join('/')}" if query[:illustrator_id]

    query[:cache_key] = key
    query
  end

end

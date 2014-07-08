class ViewerController < ApplicationController

  def index
    code = params[:code]
    @ptm = (!code.blank? && parse_pt_code(code)) ? code : ''
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
    params.permit([:job, :rarity, :weapon, :recently])
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

    job = [org[:job]].flatten.uniq.compact.select{|j| j.upcase!; Arcana::JOB_TYPES.include?(j)}
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
    weapon = [org[:weapon]].flatten.uniq.compact.select{|j| j.upcase!; Arcana::WEAPON_TYPES.include?(j)}

    query = {}
    query[:job_type] = (job.size == 1 ? job.first : job) unless job.blank?
    query[:rarity] = (rarity.size == 1 ? rarity.first : rarity) unless rarity.blank?
    query[:weapon_type] = (weapon.size == 1 ? weapon.first : weapon) unless weapon.blank?

    query[:cache_key] = "arcanas_j:#{job.sort.join}_r:#{rarity.to_a.join}_w:#{weapon.sort.join}" unless query.empty?
    query
  end

end

class Api::ArcanasController < ApplicationController
  def conditions
    render json: ArcanaCache.conditions
  end

  def latestinfo
    render json: ArcanaCache.latestinfo
  end

  def search
    as = search_arcanas(query_params)
    render json: (as || {})
  end

  def ptm
    ret = search_members(params[:ptm])
    render json: (ret || {})
  end

  def codes
    as = specified_arcanas(params[:codes])
    render json: (as || [])
  end

  def name_search
    as = search_from_name(params[:name])
    render json: (as || [])
  end

  def request_mail
    if ServerSettings.use_mail?
      mail = AdminMailer.request_mail(params[:text], ip: request.remote_ip)
      mail.deliver_later if mail
    end
    head :no_content
  end

  private

  def search_arcanas(query)
    searcher = ArcanaSearcher.parse(query)
    rsl = { detail: searcher.query_detail, result: [] }
    return rsl if searcher.blank? || searcher.query_key.blank?
    rsl[:result] = searcher.search
    rsl
  end

  def search_members(ptm)
    return {} if ptm.blank?
    mems = parse_pt_code(ptm)
    return {} unless mems

    cs = mems.values.uniq.compact
    return {} if cs.empty?
    as = from_arcana_cache(cs).each_with_object({}) { |o, h| h[o['job_code']] = o }

    ret = {}
    mems.each do |po, co|
      a = as[co]
      next unless a
      ret[po] = as[co]
    end
    ret
  end

  def specified_arcanas(codes)
    return [] if codes.blank?
    cs = codes.split('/')
    return [] if cs.blank?
    from_arcana_cache(cs)
  end

  def search_from_name(name)
    return [] if name.blank?
    return [] unless name.size > 1

    arel = Arcana.where(
      Arcana.arel_table[:name].matches("%#{name}%").or(
        Arcana.arel_table[:title].matches("%#{name}%")
      )
    ).order(
      'arcanas.rarity DESC, arcanas.cost DESC, arcanas.job_type, arcanas.job_index DESC'
    )
    codes = arel.distinct.pluck(:job_code)
    from_arcana_cache(codes)
  end
end
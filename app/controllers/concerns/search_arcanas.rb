module SearchArcanas
  extend ActiveSupport::Concern
  include PartyCode

  private

  def query_params
    params.permit(ArcanaSearcher::QUERY_CONDITION_NAMES)
  end

  def from_arcana_cache(codes)
    ArcanaCache.for_codes(codes)
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

  def code_for_member(c)
    return unless c
    c == 'N' ? nil : c
  end

  def search_arcanas(query)
    searcher = ArcanaSearcher.parse(query)
    rsl = { detail: searcher.query_detail, result: [] }
    return rsl if searcher.blank? || searcher.query_key.blank?
    rsl[:result] = searcher.search
    rsl
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
    as = from_arcana_cache(codes)

    { detail: "名前 - #{name}", result: as }
  end
end

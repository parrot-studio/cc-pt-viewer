class ViewerController < ApplicationController

  before_action only: [:ptedit, :database] do
    @actors = actors
    @illustrators = illustrators
    @mode = action_name
  end

  def ptedit
    code = params[:code]
    mems = parse_pt_code(code)
    @ptm = mems ? code : ''
    @uri = (@ptm.present? ? URI.join(root_url, @ptm).to_s : root_url)
    @title = (@ptm.present? ? create_member_title(mems) : '')
  end

  def database
    searcher = ArcanaSearcher.parse(query_params)
    @uri = (searcher.present? ? "#{db_url}?#{searcher.query_string}" : db_url)
    @title = (searcher.present? ? "[検索] #{searcher.query_detail}" : 'データベースモード')
  end

  def arcanas
    as = search_arcanas(query_params)
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

  def actors
    with_cache('actors') do
      VoiceActor.order('count DESC, name').to_a
    end
  end

  def illustrators
    with_cache('illustrators') do
      Illustrator.order(:name).to_a
    end
  end

  def parse_pt_code(code)
    return if code.blank?
    parser = /\AV(\d+)(.+)\z/
    m = code.upcase.match(parser)
    return unless m

    ver = m[1].to_i
    part = m[2]
    case ver
    when 1
      parse_pt_code_not_chained(part)
    when 2
      parse_pt_code_with_chain(part)
    end
  end

  def parse_pt_code_not_chained(code)
    return if code.blank?
    part = "([#{Arcana::JOB_TYPES.join}]\\d+|N)"
    parser = /\A#{part * 7}\z/
    m = code.upcase.match(parser)
    return unless m

    selector = ->(c) { c == 'N' ? nil : c }
    {
      mem1: selector.call(m[1]),
      mem2: selector.call(m[2]),
      mem3: selector.call(m[3]),
      mem4: selector.call(m[4]),
      sub1: selector.call(m[5]),
      sub2: selector.call(m[6]),
      friend: selector.call(m[7])
    }
  end

  def parse_pt_code_with_chain(code)
    return if code.blank?
    part = "([#{Arcana::JOB_TYPES.join}]\\d+|N)"
    parser = /\A#{part * 14}\z/
    m = code.upcase.match(parser)
    return unless m

    selector = ->(c) { c == 'N' ? nil : c }
    {
      mem1: selector.call(m[1]),
      mem1c: selector.call(m[2]),
      mem2: selector.call(m[3]),
      mem2c: selector.call(m[4]),
      mem3: selector.call(m[5]),
      mem3c: selector.call(m[6]),
      mem4: selector.call(m[7]),
      mem4c: selector.call(m[8]),
      sub1: selector.call(m[9]),
      sub1c: selector.call(m[10]),
      sub2: selector.call(m[11]),
      sub2c: selector.call(m[12]),
      friend: selector.call(m[13]),
      friendc: selector.call(m[14])
    }
  end

  def create_member_title(mems)
    keys = [:mem1, :mem2, :mem3, :mem4, :sub1, :sub2, :friend]
    names = []
    keys.each do |k|
      c = mems[k]
      next if c.blank?
      names << Arcana.find_by(job_code: c).name
    end
    names.join(', ')
  end

  def query_params
    params.permit(ArcanaSearcher::QUERY_CONDITION_NAMES)
  end

  def search_arcanas(query)
    searcher = ArcanaSearcher.parse(query)
    return [] if searcher.blank? || searcher.query_key.blank?
    with_cache("arcanas_#{searcher.query_key}") do
      searcher.search.map(&:serialize)
    end
  end

  def search_members(ptm)
    return {} if ptm.blank?
    mems = parse_pt_code(ptm)
    return {} unless mems

    cs = mems.values.uniq.compact
    return {} if cs.empty?
    as = Arcana.where(job_code: cs).index_by(&:job_code)

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
    Arcana.where(job_code: cs).map(&:serialize)
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

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def query_params
    params.permit(ArcanaSearcher::QUERY_CONDITION_NAMES)
  end

  def from_arcana_cache(codes)
    ArcanaCache.for_codes(codes)
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
end

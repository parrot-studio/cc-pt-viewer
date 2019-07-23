module PartyCode
  extend ActiveSupport::Concern

  private

  DEFAULT_MEMBER_CODE = 'V3F362NK160K151A157NP95NF305F273M194NF272F274M261'.freeze
  LAST_MEMBER_COOKIE_NAME = 'last-members'.freeze

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
    when 3
      parse_pt_code_with_hero(part)
    end
  end

  def parse_pt_code_not_chained(code)
    m = split_pt_code(code, 7)
    return unless m

    {
      mem1: code_for_member(m[1]),
      mem1c: nil,
      mem2: code_for_member(m[2]),
      mem2c: nil,
      mem3: code_for_member(m[3]),
      mem3c: nil,
      mem4: code_for_member(m[4]),
      mem4c: nil,
      sub1: code_for_member(m[5]),
      sub1c: nil,
      sub2: code_for_member(m[6]),
      sub2c: nil,
      friend: code_for_member(m[7]),
      friendc: nil,
      hero: nil
    }
  end

  def parse_pt_code_with_chain(code)
    parse_pt_code_with_hero("#{code}N")
  end

  # rubocop:disable Metrics/AbcSize
  def parse_pt_code_with_hero(code)
    m = split_pt_code(code, 15)
    return unless m

    {
      mem1: code_for_member(m[1]),
      mem1c: code_for_member(m[2]),
      mem2: code_for_member(m[3]),
      mem2c: code_for_member(m[4]),
      mem3: code_for_member(m[5]),
      mem3c: code_for_member(m[6]),
      mem4: code_for_member(m[7]),
      mem4c: code_for_member(m[8]),
      sub1: code_for_member(m[9]),
      sub1c: code_for_member(m[10]),
      sub2: code_for_member(m[11]),
      sub2c: code_for_member(m[12]),
      friend: code_for_member(m[13]),
      friendc: code_for_member(m[14]),
      hero: code_for_member(m[15])
    }
  end
  # rubocop:enable Metrics/AbcSize

  def split_pt_code(code, size)
    return if code.blank? || size < 1

    part = "([#{Arcana::JOB_TYPES.join}]\\d+|N)"
    parser = /\A#{part * size}\z/
    code.upcase.match(parser)
  end
end

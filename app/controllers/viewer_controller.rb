class ViewerController < ApplicationController

  before_action only: [:ptedit, :database] do
    @mode = action_name
  end

  def ptedit
    code = params[:code]
    mems = parse_pt_code(code)
    (redirect_to root_url; return) if (code.present? && mems.blank?)
    @ptm = mems ? code : ''
    @uri = (@ptm.present? ? URI.join(root_url, @ptm).to_s : root_url)
    @title = (@ptm.present? ? create_member_title(mems) : '')
    render :app
  end

  def database
    searcher = ArcanaSearcher.parse(query_params)
    @uri = (searcher.present? ? "#{db_url}?#{searcher.query_string}" : db_url)
    @title = (searcher.present? ? "[検索] #{searcher.query_detail}" : 'データベースモード')
    render :app
  end

  def conditions
    if stale?(last_modified: ServerSettings.data_update_time, etag: 'conditions')
      conds = with_cache('conditions') { create_conditions }
      render json: conds
    end
  end

  def arcanas
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

  def about
    fresh_when last_modified: ServerSettings.data_update_time, etag: 'about'
  end

  def changelogs
    fresh_when last_modified: ServerSettings.data_update_time, etag: 'hangelogs'
  end

  private

  def voiceactors
    ret = []
    VoiceActor.order(:name).each do |act|
      ret << [act.id, act.name]
    end
    ret
  end

  def illustrators
    ret = []
    Illustrator.order(:name).each do |ill|
      ret << [ill.id, ill.name]
    end
    ret
  end

  def create_conditions
    {
      unions: Arcana::UNION_NAMES.reject { |k, _| k == :unknown }.to_a,
      sourcecategorys: Arcana::SOURCE_CATEGORYS,
      sources: Arcana::SOURCE_CONDS,
      skillcategorys: SkillEffect::CATEGORY_CONDS,
      skillsubs: SkillEffect::SUBCATEGORY_CONDS,
      skilleffects: SkillEffect::SUBEFFECT_CONDS,
      abilitycategorys: AbilityEffect::CATEGORY_CONDS,
      abilityeffects: AbilityEffect::EFFECT_CONDS,
      abilityconditions: AbilityEffect::CONDITION_CONDS,
      chainabilitycategorys: AbilityEffect.chain_ability_categorys,
      chainabilityeffects: AbilityEffect.chain_ability_effects,
      chainabilityconditions: AbilityEffect.chain_ability_conditions,
      voiceactors: voiceactors,
      illustrators: illustrators,
      latestinfo: Changelog.latest.as_json
    }
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
    rsl = { detail: searcher.query_detail, result: [] }
    return rsl if searcher.blank? || searcher.query_key.blank?
    with_cache("arcanas_#{searcher.query_key}") do
      rsl[:result] = searcher.search.map(&:serialize)
      rsl
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

  def search_from_name(name)
    return [] if name.blank?
    return [] unless name.size > 1

    arel = Arcana.where(
      Arcana.arel_table[:name].matches("%#{name}%").or(
        Arcana.arel_table[:title].matches("%#{name}%"))
    ).order(
      'arcanas.rarity DESC, arcanas.cost DESC, arcanas.job_type, arcanas.job_index DESC'
    )
    arel.map(&:serialize)
  end

  def with_cache(name, &b)
    return unless (name && b)
    Rails.cache.fetch(name, &b)
  end

end

# rubocop:disable Metrics/ClassLength, Metrics/MethodLength, Metrics/PerceivedComplexity
class ViewerController < ApplicationController
  include SearchArcanas

  before_action only: %i[ptedit database detail] do
    parse_params_from_cookie

    @mode =
      case action_name.to_s
      when 'database'
        'database'
      else
        'ptedit'
      end
  end

  def ptedit
    code = params[:code]
    mems = parse_pt_code(code)
    if (code.present? && mems.blank?)
      redirect_to root_url
      return
    end
    ptm = mems ? code : ''
    @party_view = (ptm.present? ? true : false)
    @uri = (@party_view ? URI.join(root_url, ptm).to_s : root_url)
    @title = (@party_view ? create_member_title(mems) : '')
    @party = search_first_members(ptm)
    @results = search_first_results

    render :app
  end

  def database
    searcher = ArcanaSearcher.parse(query_params)
    @uri = (searcher.present? ? "#{db_url}?#{searcher.query_string}" : db_url)
    @title = (searcher.present? ? "[検索] #{searcher.query_detail}" : 'データベースモード')
    @query = searcher.query_string
    @results = search_first_results(query_params)

    render :app
  end

  def detail
    arcana = from_arcana_cache(params[:code]).try(:first)
    if arcana.blank?
      redirect_to root_url
      return
    end
    @arcana = arcana
    @uri = root_url
    @title = arcana['wiki_link_name']
    @party = search_first_members
    @results = search_from_name(arcana['name'])

    render :app
  end

  def about
    fresh_when last_modified: ServerSettings.data_update_time, etag: 'about'
  end

  def changelogs
    fresh_when last_modified: ServerSettings.data_update_time, etag: 'changelogs'
  end

  def cc3; end

  private

  def create_member_title(mems)
    keys = %i[mem1 mem2 mem3 mem4 sub1 sub2 friend]
    codes = keys.map { |k| mems[k] }.compact
    as = from_arcana_cache(codes)
    as.map { |a| a['name'] }.join(', ')
  end

  def parse_params_from_cookie
    @cookie =
      begin
        Oj.load(cookies['ccpts']) || {}
      rescue
        {}
      end

    @query_logs =
      begin
        obj = Oj.load(cookies['ccpts_query_logs']) || {}
        obj['query-log'] || []
      rescue
        []
      end

    @tutorial = @cookie['tutorial'].present? ? true : false
    @latest_info = create_latest_info
    @favorites = @cookie.fetch('fav-arcana', '').to_s.split('/')
    @last_members = @cookie.fetch('last-members', '')
    @last_members = DEFAULT_MEMBER_CODE if @last_members.blank?

    @parties =
      begin
        Oj.load(@cookie['parties'])
      rescue
        []
      end
  end

  def create_latest_info
    info = Changelog.latest
    return unless info

    last_ver = @cookie.fetch('latest-info', '')
    info.version.to_s == last_ver.to_s ? nil : info.as_json
  end

  def search_first_results(query = nil)
    query = { recently: ServerSettings.recently } if query.blank?
    search_arcanas(query)
  end

  def search_first_members(ptm = nil)
    ptm = @cookie[LAST_MEMBER_COOKIE_NAME] if ptm.blank?
    ptm = DEFAULT_MEMBER_CODE if ptm.blank?
    search_members(ptm)
  end
end
# rubocop:enable Metrics/ClassLength, Metrics/MethodLength, Metrics/PerceivedComplexity

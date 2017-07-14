class ViewerController < ApplicationController
  before_action only: %i[ptedit database detail] do
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

  def detail
    arcana = from_arcana_cache(params[:code]).first
    if arcana.blank?
      redirect_to root_url
      return
    end
    @code = arcana['job_code']
    @uri = root_url
    @title = arcana['wiki_link_name']
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
end

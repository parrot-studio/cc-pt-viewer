module ViewerHelper
  def data_version
    ServerSettings.data_version
  end

  def pt_version
    ServerSettings.pt_version
  end

  def mode_name(mode = nil)
    mode ||= action_name
    case mode
    when 'ptedit'
      'パーティー編集モード'
    when 'database'
      'データベースモード'
    end
  end

  def site_title
    'Get our light! - チェンクロ パーティーシミュレーター'
  end

  def ptedit_mode?
    action_name == 'ptedit'
  end

  def database_mode?
    action_name == 'database'
  end

  def main_view?
    ptedit_mode? || database_mode? ? true : false
  end

  def show_ads?(ptm)
    return true unless ptedit_mode?

    ptm.blank? ? false : true
  end
end

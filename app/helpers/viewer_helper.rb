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
      'データベースモード（β版）'
    end
  end

  def ptedit_mode?
    action_name == 'ptedit' ? true : false
  end

  def database_mode?
    action_name == 'database' ? true : false
  end

  def main_view?
    (ptedit_mode? || database_mode?) ? true : false
  end

  def show_ads?
    return true unless ptedit_mode?
    @ptm.blank? ? false : true
  end

end

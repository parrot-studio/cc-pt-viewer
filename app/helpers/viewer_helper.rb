module ViewerHelper

  def pt_path
    ServerSettings.app_path
  end

  def data_version
    ServerSettings.data_version
  end

  def pt_version
    ServerSettings.pt_version
  end

end

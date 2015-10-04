class ServerSettings < Settingslogic
  source File.expand_path('../../config/settings.yml', __FILE__)
  namespace Rails.env
  load!

  def data_version
    unless @data_version
      update_data_version! unless File.exist?(version_file)
      @data_version = File.read(version_file).chomp
    end
    @data_version
  end

  def update_data_version!(ver = nil)
    ver ||= format_time(Time.zone.now)
    File.open(version_file, 'w') { |f| f.puts(ver) }
    @data_version = ver
  end

  def use_mail?
    self.mail ? true : false
  end

  private

  def version_file
    Rails.root.join('tmp', 'data_version')
  end

  def format_time(t)
    t.strftime('%Y%m%d%H%M%S')
  end

end

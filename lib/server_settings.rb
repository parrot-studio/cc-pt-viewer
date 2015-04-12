class ServerSettings < Settingslogic
  source File.expand_path('../../config/settings.yml', __FILE__)
  namespace Rails.env
  load!

  def job_types
    split_types(jobs)
  end

  def weapon_types
    split_types(weapons)
  end

  def addition_types
    split_types(additions).map(&:to_s)
  end

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

  private

  def split_types(str)
    str.split(' ').reject(&:blank?).uniq.compact
  end

  def version_file
    Rails.root.join('tmp', 'data_version')
  end

  def format_time(t)
    t.strftime('%Y%m%d%H%M%S')
  end

end

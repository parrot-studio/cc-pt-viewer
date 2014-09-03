class ServerSettings < Settingslogic
  source File.expand_path('../../config/settings.yml', __FILE__)
  namespace Rails.env
  load!

  def job_types
    split_types(self.jobs)
  end

  def weapon_types
    split_types(self.weapons)
  end

  def source_names
    split_types(self.sources)
  end

  def growth_types
    split_types(self.growths)
  end

  def addition_types
    split_types(self.additions).map(&:to_s)
  end

  def data_version
    unless @data_version
      update_data_version! unless File.exist?(version_file)
      @data_version = File.read(version_file).chomp
    end
    @data_version
  end

  def update_data_version!(ver = nil)
    ver ||= format_time(DateTime.now)
    File.open(version_file, 'w'){|f| f.puts(ver) }
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
    format("%04d%02d%02d%02d%02d%02d",
      t.year, t.month, t.day, t.hour, t.min, t.sec)
  end

end

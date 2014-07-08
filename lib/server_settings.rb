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

  def hometown_names
    split_types(self.hometowns)
  end

  def source_names
    split_types(self.sources)
  end

  private

  def split_types(str)
    str.split(' ').reject(&:blank?).uniq.compact
  end

end

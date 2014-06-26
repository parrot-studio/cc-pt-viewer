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

  private

  def split_types(str)
    str.split(' ').reject(&:blank?).uniq.compact
  end

end

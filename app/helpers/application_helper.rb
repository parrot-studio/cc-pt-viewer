module ApplicationHelper

  def analytics
    path = Rails.root.join('tmp', 'analytics.txt')
    return '' unless File.exist?(path)
    File.read(path)
  end

end

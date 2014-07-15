module ApplicationHelper

  def analytics
    path = File.join(Rails.root, 'tmp', 'analytics.txt')
    return '' unless File.exist?(path)
    File.read(path)
  end

end

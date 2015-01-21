module ApplicationHelper

  def analytics
    path = Rails.root.join('tmp', 'analytics.txt')
    return '' unless File.exist?(path)
    File.read(path)
  end

  def adsense
    path = Rails.root.join('tmp', 'adsense.txt')
    return '' unless File.exist?(path)
    File.read(path)
  end

  def amazon
    path = Rails.root.join('tmp', 'amazon.txt')
    return '' unless File.exist?(path)
    File.read(path)
  end

end

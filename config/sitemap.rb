SitemapGenerator::Sitemap.default_host = 'https://ccpts.parrot-studio.com'

SitemapGenerator::Sitemap.create do
  add '/about', changefreq: 'monthly'
  add '/changelogs'

  Arcana.find_each do |a|
    add "/data/#{a.job_code}/#{URI.encode_www_form_component(a.origin_name)}",
        lastmod: (a.data_updated_at || Time.current), priority: 0.7
  end
end

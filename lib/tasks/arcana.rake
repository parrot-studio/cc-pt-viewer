namespace :arcana do
  desc 'import arcanas from csv (and rebuild cache)'
  task import: :environment do
    ArcanaImporter.execute
    ServerSettings.update_data_version!
    ArcanaCache.rebuild
  end

  desc 'rebuild arcanas cache'
  task rebuild: :environment do
    ServerSettings.update_data_version!
    ArcanaCache.rebuild
  end

  desc 'Wiki access Test'
  task wikitest: :environment do
    count = Arcana.count
    reg = %r{\AHTTP/1.1 200 OK}

    Arcana.all.each.with_index(1) do |a, i|
      sleep 2
      uri = URI.join('https://xn--eckfza0gxcvmna6c.gamerch.com', ERB::Util.url_encode(a.wiki_link_name))
      res = `curl -I -s #{uri}`

      if res.match?(reg)
        puts "now: #{i}/#{count}" if (i % 50).zero?
        next
      else
        puts "access failed => #{a.wiki_link_name}"
      end
    end
  end
end

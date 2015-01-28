namespace :arcana do

  desc "Import Arcanas from CSV"
  task :import => :environment do
    ArcanaImporter.execute
    Rails.cache.clear
    ServerSettings.update_data_version!
  end

  desc "Wiki access Test"
  task :wikitest => :environment do
    Arcana.all.each do |a|
      sleep 3
      wikiname = "#{a.title}#{a.name}"
      uri = URI.join("http://xn--eckfza0gxcvmna6c.gamerch.com", ERB::Util.url_encode(wikiname))
      res = Net::HTTP.get_response(uri)
      case res
      when Net::HTTPOK
        next
      else
        puts "access failed => #{wikiname}"
      end
    end
  end

end

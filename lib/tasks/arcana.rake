namespace :arcana do

  desc "Import Arcanas from CSV"
  task :import => :environment do
    ArcanaImporter.execute
    Rails.cache.clear
    ServerSettings.update_data_version!
  end

end

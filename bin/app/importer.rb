file = ARGV[0]
unless file
  puts "usage: rails r importer.rb [file]"
  exit
end

f = File.open(file, 'rt:Shift_JIS')
Arcana.transaction do
  f.readlines.each do |line|
    next if line.start_with?('#')
    name, title, rarity, job_type, cost, wp, ht, job_index = line.chomp.split(',')
    next if name.blank?

    code = "#{job_type}#{job_index.to_i}"
    arcana = Arcana.find_by_job_code(code) || Arcana.new
    arcana.name = name.gsub(/"""/, '"')
    arcana.title = title.gsub(/"""/, '"')
    arcana.rarity = rarity.to_i
    arcana.cost = cost.to_i
    arcana.weapon_type = wp
    arcana.hometown = ht
    arcana.job_type = job_type
    arcana.job_index = job_index.to_i
    arcana.job_code = code
    arcana.save!
  end
end

Rails.cache.clear

exit

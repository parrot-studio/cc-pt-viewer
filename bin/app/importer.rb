file = ARGV[0]
unless file
  puts "usage: rails r importer.rb [file]"
  exit
end

f = File.open(file, 'rt:Shift_JIS')
Arcana.transaction do
  f.readlines.each do |line|
    next if line.start_with?('#')
    name, title, rarity, job_type, job_index = line.chomp.split(',')
    next if name.blank?

    arcana = Arcana.find_by_name(name) || Arcana.new
    arcana.name = name.gsub(/"""/, '"')
    arcana.title = title.gsub(/"""/, '"')
    arcana.rarity = rarity.to_i
    arcana.job_type = job_type
    arcana.job_index = job_index.to_i
    arcana.job_code = "#{job_type}#{job_index.to_i}"
    arcana.save!
  end
end

exit

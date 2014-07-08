file = ARGV[0]
unless file
  puts "usage: rails r importer.rb [file]"
  exit
end

f = File.open(file, 'rt:Shift_JIS')
Arcana.transaction do
  actors = VoiceActor.all.index_by(&:name)
  illusts = Illustrator.all.index_by(&:name)

  f.readlines.each do |line|
    next if line.start_with?('#')
    name, title, rarity, job_type, cost, wp, ht, so, vn, iname, job_index = line.split(',').map(&:strip)
    next if name.blank?

    code = "#{job_type}#{job_index.to_i}"
    arcana = Arcana.find_by_job_code(code) || Arcana.new
    arcana.name = name.gsub(/"""/, '"')
    arcana.title = title.gsub(/"""/, '"')
    arcana.rarity = rarity.to_i
    arcana.cost = cost.to_i
    arcana.weapon_type = wp
    arcana.hometown = ht
    arcana.source = so
    arcana.job_type = job_type
    arcana.job_index = job_index.to_i
    arcana.job_code = code

    actor = actors[vn] || lambda do |name|
      va = VoiceActor.new
      va.name = name
      va.save!
      actors[name] = va
      va
    end.call(vn)
    arcana.voice_actor = actor

    illust = illusts[iname] || lambda do |name|
      il = Illustrator.new
      il.name = name
      il.save!
      illusts[name] = il
      il
    end.call(iname)
    arcana.illustrator = illust

    arcana.save!
  end

  VoiceActor.all.each do |va|
    va.count = Arcana.where(voice_actor_id: va.id).count
    va.save!
  end

  Illustrator.all.each do |il|
    il.count = Arcana.where(illustrator_id: il.id).count
    il.save!
  end

end

Rails.cache.clear

exit

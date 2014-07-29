file = ARGV[0]
unless file
  puts "usage: rails r importer.rb [file]"
  exit
end

f = File.open(file, 'rt:Shift_JIS')
Arcana.transaction do
  actors = VoiceActor.all.index_by(&:name)
  illusts = Illustrator.all.index_by(&:name)
  skills = Skill.all.index_by(&:name)

  f.readlines.each do |line|
    next if line.start_with?('#')

    datas = line.split(',').map(&:strip)
    name = datas[0].gsub(/"""/, '"')
    next if name.blank?
    title = datas[1].gsub(/"""/, '"')
    rarity = datas[2].to_i
    job_type = datas[3]
    cost = datas[4].to_i
    weapon = datas[5]
    home = datas[6]
    source = datas[7]
    vname = datas[8]
    iname = datas[9]
    growth = datas[10]
    addition = datas[11].to_s
    sname = datas[12]
    scate = datas[13]
    ssubcate = datas[14]
    scost = datas[15].to_i
    matk = datas[16].to_i
    mhp = datas[17].to_i
    latk = datas[18].to_i
    lhp = datas[19].to_i
    job_detail = datas[20]
    job_index = datas[21].to_i
    code = "#{job_type}#{job_index}"

    arcana = Arcana.find_by_job_code(code) || Arcana.new
    arcana.name = name
    arcana.title = title
    arcana.rarity = rarity
    arcana.cost = cost
    arcana.weapon_type = weapon
    arcana.hometown = home
    arcana.source = source
    arcana.growth_type = growth
    arcana.addition = addition
    arcana.job_type = job_type
    arcana.job_index = job_index
    arcana.job_code = code
    arcana.max_atk = (matk > 0 ? matk : nil)
    arcana.max_hp = (mhp > 0 ? mhp : nil)
    arcana.limit_atk = (latk > 0 ? latk : nil)
    arcana.limit_hp = (lhp > 0 ? lhp : nil)
    arcana.job_detail = job_detail

    actor = actors[vname] || lambda do |name|
      va = VoiceActor.new
      va.name = name
      va.save!
      actors[name] = va
      va
    end.call(vname)
    arcana.voice_actor = actor

    illust = illusts[iname] || lambda do |name|
      il = Illustrator.new
      il.name = name
      il.save!
      illusts[name] = il
      il
    end.call(iname)
    arcana.illustrator = illust

    skill = skills[sname] || lambda do |name, category, sub, cost|
      sk = Skill.new
      sk.name = name
      sk.category = category
      sk.subcategory = sub
      sk.cost = cost
      sk.explanation = ''
      sk.save!
      skills[name] = sk
      sk
    end.call(sname, scate, ssubcate, scost)
    arcana.skill = skill

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

class ArcanaImporter

  attr_writer :file_dir

  class << self

    def execute(fdir: nil)
      ai = self.new
      ai.file_dir = fdir if fdir
      ai.execute
    end

  end

  def execute
    Arcana.transaction do
      each_table_lines(arcana_table_file) do |datas|
        import_arcana(datas)
      end
    end
    self
  end

  private

  def db_file_dir
    @file_dir ||= File.expand_path(File.join(Rails.root, 'db'))
    @file_dir
  end

  def id_table_file
    File.join(db_file_dir, 'id.csv')
  end

  def arcana_table_file
    File.join(db_file_dir, 'arcanas.csv')
  end

  def each_table_lines(file)
    raise "file not found => #{file}" unless File.exist?(file)
    f = File.open(file, 'rt:Shift_JIS')
    f.readlines.each do |line|
      next if line.start_with?('#')
      datas = line.split(',').map(&:strip)
      next if datas.empty?
      next if datas.all?(&:blank?)
      yield(datas)
    end
    file
  end

  def id_table
    @ids ||= lambda do
      ret = {}
      each_table_lines(id_table_file) do |datas|
        name, job, index = datas
        next if (name.blank? || job.blank? || index.blank?)
        ret["#{job}#{index}"] = name
      end
      ret
    end.call
    @ids
  end

  def valid_arcana?(code, name)
    id_table[code] == name ? true : false
  end

  def actors
    @actors ||= VoiceActor.all.index_by(&:name)
    @actors
  end

  def illusts
    @illusts ||= Illustrator.all.index_by(&:name)
    @illusts
  end

  def skills
    @skills ||= Skill.all.index_by(&:name)
    @skills
  end

  def import_arcana(datas)
    name = datas[0].gsub(/"""/, '"')
    return if name.blank?

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

    raise "invalid arcana => code:#{code} name:#{name}" unless valid_arcana?(code, name)

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
    arcana
  end

end

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

      VoiceActor.all.each do |va|
        va.count = Arcana.where(voice_actor_id: va.id).count
        va.save!
      end

      Illustrator.all.each do |il|
        il.count = Arcana.where(illustrator_id: il.id).count
        il.save!
      end
    end

    self
  end

  private

  def db_file_dir
    @file_dir ||= Rails.root.join('db')
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

  def abilities
    @abilities ||= Ability.all.index_by(&:name)
    @abilities
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
    sname = datas[11]
    scate = datas[12]
    ssubcate = datas[13]
    scost = datas[14].to_i
    name2 = datas[15]
    raise "name invalid" unless name == name2
    matk = datas[16].to_i
    mhp = datas[17].to_i
    latk = datas[18].to_i
    lhp = datas[19].to_i
    job_detail = datas[20]
    ability_name_1 = datas[21]
    ability_cond_1_1 = datas[22]
    ability_effect_1_1 = datas[23]
    ability_cond_1_2 = datas[24]
    ability_effect_1_2 = datas[25]
    ability_name_2 = datas[26]
    ability_cond_2_1 = datas[27]
    ability_effect_2_1 = datas[28]
    ability_cond_2_2 = datas[29]
    ability_effect_2_2 = datas[30]
    job_index = datas[31].to_i
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
    arcana.job_type = job_type
    arcana.job_index = job_index
    arcana.job_code = code
    arcana.max_atk = (matk > 0 ? matk : nil)
    arcana.max_hp = (mhp > 0 ? mhp : nil)
    arcana.limit_atk = (latk > 0 ? latk : nil)
    arcana.limit_hp = (lhp > 0 ? lhp : nil)
    arcana.job_detail = job_detail

    unless vname.blank?
      actor = actors[vname] || lambda do |name|
        va = VoiceActor.new
        va.name = name
        va.save!
        actors[name] = va
        va
      end.call(vname)
      arcana.voice_actor = actor
    end

    unless iname.blank?
      illust = illusts[iname] || lambda do |name|
        il = Illustrator.new
        il.name = name
        il.save!
        illusts[name] = il
        il
      end.call(iname)
      arcana.illustrator = illust
    end

    unless sname.blank?
      skill = lambda do |name, category, sub, cost|
        sk = skills[name]
        if sk
          check = lambda do
            next false unless sk.category == category
            next false unless sk.subcategory == sub
            next false unless sk.cost == cost
            true
          end.call
          puts "warning : skill data invalid => #{arcana.name} #{sk.inspect}" unless check
        else
          sk = Skill.new
          sk.name = name
        end

        sk.category = category
        sk.subcategory = sub
        sk.cost = cost
        sk.explanation = ''
        sk.save!
        skills[name] = sk
        sk
      end.call(sname, scate, ssubcate, scost)
      arcana.skill = skill
    end

    create_ability = lambda do |name, cond1, effect1, cond2, effect2|
      abi = abilities[name]
      if abi
        check = lambda do
          next false unless abi.condition_type == cond1
          next false unless abi.effect_type == effect1
          next false unless abi.condition_type_second.to_s == cond2
          next false unless abi.effect_type_second.to_s == effect2
          true
        end.call
        puts "warning : ability data invalid => #{arcana.name} #{abi.inspect}" unless check
      else
        abi = Ability.new
        abi.name = name
      end

      abi.condition_type = cond1
      abi.effect_type = effect1
      abi.condition_type_second = (cond2.blank? ? nil : cond2)
      abi.effect_type_second = (effect2.blank? ? nil : effect2)
      abi.explanation = ''
      abi.save!
      abilities[name] = abi
      abi
    end

    unless ability_name_1.blank?
      abi1 = create_ability.call(ability_name_1,
        ability_cond_1_1, ability_effect_1_1,
        ability_cond_1_2, ability_effect_1_2)
      arcana.first_ability = abi1
    end

    unless ability_name_2.blank?
      abi2 = create_ability.call(ability_name_2,
        ability_cond_2_1, ability_effect_2_1,
      ability_cond_2_2, ability_effect_2_2)
      arcana.second_ability = abi2
    end

    arcana.save!
    arcana
  end

end

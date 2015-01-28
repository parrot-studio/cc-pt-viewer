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
      build_skill
      build_ability
      build_chain_ability

      each_table_lines(arcana_table_file) do |datas|
        import_arcana(datas)
      end

      VoiceActor.all.each do |va|
        va.count = Arcana.where(voice_actor_id: va.id).count
        if va.count > 0
          va.save!
        else
          puts "warning : VoiceActor count 0 => #{va.name}"
          va.destroy
        end
      end

      Illustrator.all.each do |il|
        il.count = Arcana.where(illustrator_id: il.id).count
        if il.count > 0
          il.save!
        else
          puts "warning : Illustrator count 0 => #{il.name}"
          il.destroy
        end
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

  def skill_table_file
    File.join(db_file_dir, 'skill.csv')
  end

  def ability_table_file
    File.join(db_file_dir, 'ability.csv')
  end

  def chain_ability_table_file
    File.join(db_file_dir, 'chain_ability.csv')
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
    @skills || {}
  end

  def abilities
    @abilities || {}
  end

  def chain_abilities
    @chain_abilities || {}
  end

  def build_skill
    skills = Skill.all.index_by(&:name)

    each_table_lines(skill_table_file) do |datas|
      3.times{ datas.shift } # name, job, index
      name = datas.shift
      cost = datas.shift
      next if (name.blank? || cost.blank?)

      sk = skills[name]
      unless sk
        sk = Skill.new
        sk.name = name
        skills[name] = sk
      end
      sk.cost = cost.to_i
      sk.explanation = ''

      efs = sk.skill_effects.index_by(&:order)
      es = []
      ord = 1
      loop do
        break if datas.blank?
        cate = datas.shift
        scate = datas.shift
        se1 = datas.shift
        se2 = datas.shift
        break if cate.blank? && scate.blank?
        raise "skill data invalid => #{sk.name} / category:#{cate} subcategory:#{scate}" if cate.blank? || scate.blank?

        ef = efs[ord] || SkillEffect.new
        check = lambda do
          next false unless ef.category == cate
          next false unless ef.subcategory == scate
          next false unless ef.subeffect1.to_s == se1.to_s
          next false unless ef.subeffect2.to_s == se2.to_s
          true
        end.call
        puts "warning : skill data invalid => #{sk.name} #{ef.inspect}" unless check

        ef.order = ord
        ef.category = cate
        ef.subcategory = scate
        ef.subeffect1 = se1
        ef.subeffect2 = se2
        es << ef
        ord += 1
      end
      sk.skill_effects = es
      sk.skill_effects.each(&:save!)
      sk.save!
    end

    @skills = skills
  end

  def build_ability
    abs = Ability.all.index_by(&:name)
    effects = AbilityEffect.all.inject({}) do |h, e|
      h["#{e.condition_type}|#{e.effect_type}"] = e
      h
    end

    each_table_lines(ability_table_file) do |datas|
      3.times{ datas.shift } # name, job, index
      name = datas.shift
      next if name.blank?

      abi = abs[name]
      unless abi
        abi = Ability.new
        abi.name = name
        abi.explanation = ''
        abs[name] = abi
      end

      effs = []
      keys = []
      loop do
        break if datas.blank?
        cond = datas.shift
        eff = datas.shift
        break if cond.blank? && eff.blank?
        raise "ability data invalid => #{abi.name} / cond:#{cond} effect:#{eff}" if cond.blank? || eff.blank?

        key = "#{cond}|#{eff}"
        ae = effects[key]
        unless ae
          ae = AbilityEffect.new
          ae.condition_type = cond
          ae.effect_type = eff
          effects[key] = ae
        end
        effs << ae
        keys << key
      end

      orgs = abi.ability_effects.map{|e| "#{e.condition_type}|#{e.effect_type}"}.sort
      abi.ability_effects = effs
      puts "warning : ability data invalid => #{abi.name} #{orgs.inspect} -> #{effs.inspect}" unless orgs == keys.sort
    end

    @abilities = abs
  end

  def build_chain_ability
    abs = ChainAbility.all.index_by(&:name)
    effects = ChainAbilityEffect.all.inject({}) do |h, e|
      h["#{e.condition_type}|#{e.effect_type}"] = e
      h
    end

    each_table_lines(chain_ability_table_file) do |datas|
      3.times{ datas.shift } # name, job, index
      name = datas.shift
      next if name.blank?

      abi = abs[name]
      unless abi
        abi = ChainAbility.new
        abi.name = name
        abi.explanation = ''
        abs[name] = abi
      end

      effs = []
      keys = []
      loop do
        break if datas.blank?
        cond = datas.shift
        eff = datas.shift
        break if cond.blank? && eff.blank?
        raise "chain_ability data invalid => #{abi.name} / cond:#{cond} effect:#{eff}" if cond.blank? || eff.blank?

        key = "#{cond}|#{eff}"
        ae = effects[key]
        unless ae
          ae = ChainAbilityEffect.new
          ae.condition_type = cond
          ae.effect_type = eff
          effects[key] = ae
        end
        effs << ae
        keys << key
      end

      orgs = abi.chain_ability_effects.map{|e| "#{e.condition_type}|#{e.effect_type}"}.sort
      abi.chain_ability_effects = effs
      puts "warning : chain_ability data invalid => #{abi.name} #{orgs.inspect} -> #{effs.inspect}" unless orgs == keys.sort
    end

    @chain_abilities = abs
  end

  def import_arcana(datas)
    name = datas[0].gsub(/"""/, '"')
    return if name.blank?

    title = datas[1].gsub(/"""/, '"')
    job_type = datas[2]
    job_index = datas[3].to_i
    code = "#{job_type}#{job_index}"
    raise "invalid arcana => code:#{code} name:#{name}" unless valid_arcana?(code, name)

    rarity = datas[4].to_i
    cost = datas[5].to_i
    chain_cost = datas[6].to_i
    weapon = datas[7]
    source_category = datas[8]
    source = datas[9]
    vname = datas[10]
    iname = datas[11]
    union = datas[12]
    skill_name = datas[13]
    name2 = datas[14]
    raise "name invalid" unless name == name2
    matk = datas[15].to_i
    mhp = datas[16].to_i
    latk = datas[17].to_i
    lhp = datas[18].to_i
    job_detail = datas[19]
    ability_name_f = datas[20]
    ability_name_s = datas[21]
    chain_ability_name = datas[22]

    arcana = Arcana.find_by_job_code(code) || Arcana.new
    arcana.name = name
    arcana.title = title
    arcana.rarity = rarity
    arcana.cost = cost
    arcana.chain_cost = chain_cost
    arcana.weapon_type = weapon
    arcana.source_category = source_category
    arcana.source = source
    arcana.union = (union.blank? ? 'unknown' : union)
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

    unless skill_name.blank?
      sk = skills[skill_name]
      raise "skill not found => #{skill_name}" unless sk
      arcana.skill = sk
    end

    unless ability_name_f.blank?
      abi1 = abilities[ability_name_f]
      raise "ability not found => #{ability_name_f}" unless abi1
      arcana.first_ability = abi1
    end

    unless ability_name_s.blank?
      abi2 = abilities[ability_name_s]
      raise "ability not found => #{ability_name_s}" unless abi2
      arcana.second_ability = abi2
    end

    unless chain_ability_name.blank?
      ca = chain_abilities[chain_ability_name]
      raise "chain_ability not found => #{chain_ability_name}" unless ca
      arcana.chain_ability = ca
    end

    arcana.save!
    arcana
  end

end

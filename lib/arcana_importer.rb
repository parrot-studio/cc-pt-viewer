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
      build_ability
      build_chain_ability

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
    @skills ||= Skill.all.index_by(&:name)
    @skills
  end

  def abilities
    @abilities || {}
  end

  def chain_abilities
    @chain_abilities || {}
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
    rarity = datas[2].to_i
    job_type = datas[3]
    cost = datas[4].to_i
    weapon = datas[5]
    source_category = datas[6]
    source = datas[7]
    vname = datas[8]
    iname = datas[9]
    union = datas[10]
    skill_name = datas[11]
    skill_cate = datas[12]
    skill_subcate = datas[13]
    skill_cost = datas[14].to_i
    skill_subeffect1 = datas[15]
    skill_subeffect2 = datas[16]
    name2 = datas[17]
    raise "name invalid" unless name == name2
    matk = datas[18].to_i
    mhp = datas[19].to_i
    latk = datas[20].to_i
    lhp = datas[21].to_i
    job_detail = datas[22]
    ability_name_f = datas[23]
    ability_name_s = datas[24]
    chain_ability_name = datas[25]
    job_index = datas[26].to_i
    code = "#{job_type}#{job_index}"

    raise "invalid arcana => code:#{code} name:#{name}" unless valid_arcana?(code, name)

    arcana = Arcana.find_by_job_code(code) || Arcana.new
    arcana.name = name
    arcana.title = title
    arcana.rarity = rarity
    arcana.cost = cost
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
      skill = lambda do |name, category, sub, cost, subeffect1, subeffect2|
        sk = skills[name]
        if sk
          check = lambda do
            next false unless sk.category == category
            next false unless sk.subcategory == sub
            next false unless sk.subeffect1.to_s == subeffect1.to_s
            next false unless sk.subeffect2.to_s == subeffect2.to_s
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
        sk.subeffect1 = (subeffect1.blank? ? nil : subeffect1)
        sk.subeffect2 = (subeffect2.blank? ? nil : subeffect2)
        sk.save!
        skills[name] = sk
        sk
      end.call(skill_name, skill_cate, skill_subcate, skill_cost, skill_subeffect1, skill_subeffect2)
      arcana.skill = skill
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

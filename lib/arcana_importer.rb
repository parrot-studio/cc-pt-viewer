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

      each_table_lines(arcana_table_file) do |data|
        import_arcana(data)
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
      data = line.split(',').map(&:strip)
      next if data.empty?
      next if data.all?(&:blank?)
      yield(data)
    end
    file
  end

  def each_ability_data_lines(file)
    lines = []
    each_table_lines(file) do |data|
      3.times { data.shift } # name, job, index
      next if data.all?(&:blank?)
      name = data.first
      if name.present?
        if lines.blank?
          lines << data
        else
          yield(lines)
          lines = [data]
        end
      else
        lines << data
      end
    end
    yield(lines) if lines.present?
    file
  end

  def id_table
    @ids ||= lambda do
      ret = {}
      each_table_lines(id_table_file) do |data|
        name, job, index = data
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

    each_table_lines(skill_table_file) do |data|
      3.times { data.shift } # name, job, index
      name = data.shift
      cost = data.shift
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
        break if data.blank?
        cate = data.shift
        scate = data.shift
        se1 = data.shift
        se2 = data.shift
        se3 = data.shift
        break if cate.blank? && scate.blank?

        ef = efs[ord] || SkillEffect.new
        ef.order = ord
        ef.category = cate
        raise "category not found => #{sk.name} #{ef.category}" unless SkillEffect::CATEGORYS.key?(ef.category.to_sym)

        check_table = SkillEffect::CATEGORYS.fetch(ef.category.to_sym, {})
        ef.subcategory = scate
        raise "subcategory not found => #{sk.name} #{ef.subcategory}" unless SkillEffect::SUBCATEGORYS.key?(ef.subcategory.to_sym)
        raise "subcategory not defined => #{sk.name} #{ef.category} #{ef.subcategory}" unless check_table.fetch(:sub, {}).fetch(ef.subcategory.to_sym, nil)

        effect_table = check_table.fetch(:effect, {})
        ef.subeffect1 = se1.to_s
        if ef.subeffect1.present?
          raise "subeffect1 not found => #{sk.name} #{ef.subeffect1}" unless SkillEffect::SUBEFFECTS.key?(ef.subeffect1.to_sym)
          raise "subeffect1 not defined => #{sk.name} #{ef.category} #{ef.subeffect1}" unless effect_table.fetch(ef.subeffect1.to_sym, nil)
        end
        ef.subeffect2 = se2.to_s
        if ef.subeffect2.present?
          raise "subeffect2 not found => #{sk.name} #{ef.subeffect1}" unless SkillEffect::SUBEFFECTS.key?(ef.subeffect2.to_sym)
          raise "subeffect2 not defined => #{sk.name} #{ef.category} #{ef.subeffect2}" unless effect_table.fetch(ef.subeffect2.to_sym, nil)
        end
        ef.subeffect3 = se3.to_s
        if ef.subeffect3.present?
          raise "subeffect3 not found => #{sk.name} #{ef.subeffect1}" unless SkillEffect::SUBEFFECTS.key?(ef.subeffect3.to_sym)
          raise "subeffect3 not defined => #{sk.name} #{ef.category} #{ef.subeffect3}" unless effect_table.fetch(ef.subeffect3.to_sym, nil)
        end

        changes = ef.changes if ef.changed?
        puts "warning : skill #{sk.name} : #{changes}" if changes.present?
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

    each_ability_data_lines(ability_table_file) do |lines|
      # アビリティ名
      name = lines.first.first
      abi = abs[name]
      unless abi
        abi = Ability.new
        abi.name = name
        abi.explanation = ''
        abi.save!
        abs[name] = abi
      end

      # 詳細
      lines.each.with_index(1) do |data, ord|
        data.shift # name
        next if data.all?(&:blank?)
        effect = abi.ability_effects.find { |e| e.order == ord }
        effect ||= AbilityEffect.new

        effect.order = ord
        effect.category = data.shift
        raise "category not found => #{abi.name} #{effect.category}" unless AbilityEffect::CATEGORYS.key?(effect.category.to_sym)
        effect.condition = data.shift
        raise "condition not found => #{abi.name} #{effect.condition}" unless AbilityEffect::CONDITIONS.key?(effect.condition.to_sym)
        effect.effect = data.shift
        raise "effect not found => #{abi.name} #{effect.effect}" unless AbilityEffect::EFFECTS.key?(effect.effect.to_sym)
        effect.target = data.shift
        raise "target not found => #{abi.name} #{effect.target}" unless AbilityEffect::TARGETS.key?(effect.target.to_sym)
        effect.note = data.shift

        # 組み合わせチェック
        check = AbilityEffect::CATEGORYS.fetch(effect.category.to_sym, {}).fetch(:effect, {}).fetch(effect.effect.to_sym, nil)
        raise "effect undefined =>  #{abi.name} #{effect.category} #{effect.effect}" unless check

        changes = effect.changes if effect.changed?
        abi.ability_effects << effect
        effect.save!

        puts "warning : ability #{name} : #{changes}" if changes.present?
      end
    end

    @abilities = abs
  end

  def build_chain_ability
    abs = ChainAbility.all.index_by(&:name)

    each_ability_data_lines(chain_ability_table_file) do |lines|
      # アビリティ名
      name = lines.first.first
      abi = abs[name]
      unless abi
        abi = ChainAbility.new
        abi.name = name
        abi.explanation = ''
        abi.save!
        abs[name] = abi
      end

      # 詳細
      lines.each.with_index(1) do |data, ord|
        data.shift # name
        next if data.all?(&:blank?)
        effect = abi.chain_ability_effects.find { |e| e.order == ord }
        effect ||= ChainAbilityEffect.new

        effect.order = ord
        effect.category = data.shift
        raise "category not found = #{abi.name}> #{effect.category}" unless AbilityEffect::CATEGORYS.key?(effect.category.to_sym)
        effect.condition = data.shift
        raise "condition not found => #{abi.name} #{effect.condition}" unless AbilityEffect::CONDITIONS.key?(effect.condition.to_sym)
        effect.effect = data.shift
        raise "effect not found => #{abi.name} #{effect.effect}" unless AbilityEffect::EFFECTS.key?(effect.effect.to_sym)
        effect.target = data.shift
        raise "target not found => #{abi.name} #{effect.target}" unless AbilityEffect::TARGETS.key?(effect.target.to_sym)
        effect.note = data.shift

        # 組み合わせチェック
        check = AbilityEffect::CATEGORYS.fetch(effect.category.to_sym, {}).fetch(:effect, {}).fetch(effect.effect.to_sym, nil)
        raise "effect undefined =>  #{abi.name} #{effect.category} #{effect.effect}" unless check

        changes = effect.changes if effect.changed?
        abi.chain_ability_effects << effect
        effect.save!

        puts "warning : chain_ability #{name} : #{changes}" if changes.present?
      end
    end

    @chain_abilities = abs
  end

  def import_arcana(data)
    name = data[0].gsub(/"""/, '"')
    return if name.blank?

    job_type = data[1]
    job_index = data[2].to_i
    code = "#{job_type}#{job_index}"
    raise "invalid arcana => code:#{code} name:#{name}" unless valid_arcana?(code, name)

    title = data[3].gsub(/"""/, '"')
    rarity = data[4].to_i
    cost = data[5].to_i
    chain_cost = data[6].to_i
    weapon = data[7]
    source_category = data[8]
    source = data[9]
    vname = data[10]
    iname = data[11]
    union = data[12]
    job_detail = data[13]
    matk = data[14].to_i
    mhp = data[15].to_i
    latk = data[16].to_i
    lhp = data[17].to_i
    name2 = data[18]
    raise 'name invalid' unless name == name2
    skill_name = data[19]
    ability_name_f = data[20]
    ability_name_s = data[21]
    chain_ability_name = data[22]

    arcana = Arcana.find_by(job_code: code) || Arcana.new
    arcana.name = name
    arcana.title = title
    arcana.rarity = rarity
    arcana.cost = cost
    arcana.chain_cost = chain_cost
    arcana.weapon_type = weapon
    raise "weapon_type not found => #{arcana.name} #{arcana.weapon_type}" unless Arcana::WEAPON_NAMES.key?(arcana.weapon_type.to_sym)
    arcana.source_category = source_category
    sct = Arcana::SOURCE_TABLE[arcana.source_category.to_sym]
    raise "source_category not found => #{arcana.name} #{arcana.source_category}" unless sct
    arcana.source = source
    raise "source not found => #{arcana.name} #{arcana.source}" unless sct.fetch(:details).fetch(arcana.source.to_sym)
    arcana.union = (union.blank? ? 'unknown' : union)
    raise "union not found => #{arcana.name} #{arcana.union}" unless Arcana::UNION_NAMES.key?(arcana.union.to_sym)
    arcana.job_type = job_type
    raise "job_type not found => #{arcana.name} #{arcana.job_type}" unless Arcana::JOB_NAMES.key?(arcana.job_type.to_sym)
    arcana.job_index = job_index
    arcana.job_code = code
    arcana.max_atk = (matk > 0 ? matk : nil)
    arcana.max_hp = (mhp > 0 ? mhp : nil)
    arcana.limit_atk = (latk > 0 ? latk : nil)
    arcana.limit_hp = (lhp > 0 ? lhp : nil)
    arcana.job_detail = job_detail

    unless vname.blank?
      actor = actors[vname] || lambda do |na|
        va = VoiceActor.new
        va.name = na
        va.save!
        actors[na] = va
        va
      end.call(vname)
      arcana.voice_actor = actor
    end

    unless iname.blank?
      illust = illusts[iname] || lambda do |na|
        il = Illustrator.new
        il.name = na
        il.save!
        illusts[na] = il
        il
      end.call(iname)
      arcana.illustrator = illust
    end

    unless skill_name.blank?
      arcana.skill = skills[skill_name]
      unless arcana.skill
        puts "skill not found => #{skill_name}"
        arcana.skill_id = 0
      end
    end

    unless ability_name_f.blank?
      arcana.first_ability = abilities[ability_name_f]
      unless arcana.first_ability
        puts "ability not found => #{ability_name_f}"
        arcana.first_ability_id = 0
      end
    end

    unless ability_name_s.blank?
      arcana.second_ability = abilities[ability_name_s]
      unless arcana.second_ability
        puts "ability not found => #{ability_name_s}"
        arcana.second_ability_id = 0
      end
    end

    unless chain_ability_name.blank?
      arcana.chain_ability = chain_abilities[chain_ability_name]
      unless arcana.chain_ability
        puts "chain_ability not found => #{chain_ability_name}"
        arcana.chain_ability_id = 0
      end
    end

    puts "warning : arcana #{arcana.name} : #{arcana.changes}" if arcana.changed?

    arcana.save!
    arcana
  end

end

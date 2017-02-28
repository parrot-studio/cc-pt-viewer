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
    ApplicationRecord.transaction do
      each_table_lines(arcana_table_file) do |data|
        import_arcana(data)
      end

      import_skill
      import_ability

      VoiceActor.all.each do |va|
        va.count = Arcana.where(voice_actor_id: va.id).count
        if va.count.positive?
          va.save!
        else
          output_warning "warning : VoiceActor count 0 => #{va.name}"
          va.destroy
        end
      end

      Illustrator.all.each do |il|
        il.count = Arcana.where(illustrator_id: il.id).count
        if il.count.positive?
          il.save!
        else
          output_warning "warning : Illustrator count 0 => #{il.name}"
          il.destroy
        end
      end
    end

    # 伝授スキルチェック
    except_types = %w(buddy third)
    implemented_collabo = %w(
      konosuba persona5 utaware valkyria falcom_sen2
      atelier_arland
    )

    except_arcanas = [
      'F211' # ミョルン
    ]

    Arcana.all.each do |a|
      next if a.rarity < 4
      next if except_types.include?(a.arcana_type)
      next if except_arcanas.include?(a.job_code)
      next if a.arcana_type == 'collaboration' && !implemented_collabo.include?(a.source)
      inherit = a.skills.find_by(skill_type: 'd')
      next if inherit
      output_warning "warning : arcana #{a.name}(#{a.job_code}/#{a.rarity}) : lack inherit skill (#{a.arcana_type})"
    end

    self
  end

  private

  def output_warning(mes)
    puts Rainbow(mes).yellow
  end

  def db_file_dir
    @file_dir ||= Rails.root.join('db', 'masters')
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

  def each_table_lines(file)
    raise "file not found => #{file}" unless File.exist?(file)
    f = File.open(file, 'rt:Shift_JIS')
    f.readlines.each do |line|
      break if line.start_with?('#end')
      next if line.start_with?('#')
      data = line.split(',').map(&:strip)
      next if data.empty?
      next if data.all?(&:blank?)
      yield(data)
    end
    file
  end

  def each_data_lines(file)
    lines = []
    code = nil
    each_table_lines(file) do |data|
      data.shift # name
      job = data.shift
      index = data.shift
      next if data.all?(&:blank?)

      if job.present? && index.present?
        yield(code, lines) if lines.present?
        code = "#{job}#{index}"
        lines = [data]
      else
        lines << data
      end
    end
    yield(code, lines) if lines.present?
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

  def stored_arcanas
    @stored_arcanas ||= Arcana.all.index_by(&:job_code)
    @stored_arcanas
  end

  def import_arcana(data)
    name = data[0].gsub(/"""/, '"')
    return if name.blank?

    job_type = data[1]
    job_index = data[2].to_i
    code = "#{job_type}#{job_index}"
    raise "invalid arcana => code:#{code} name:#{name}" unless valid_arcana?(code, name)

    arcana_type = data[3]
    person = data[4]
    person = code if person.blank?
    link = data[5]
    title = data[6].gsub(/"""/, '"')
    rarity = data[7].to_i
    cost = data[8].to_i
    chain_cost = data[9].to_i
    weapon = data[10]
    source_category = data[11]
    source = data[12]
    vname = data[13]
    iname = data[14]
    union = data[15]
    job_detail = data[16]
    matk = data[17].to_i
    mhp = data[18].to_i
    latk = data[19].to_i
    lhp = data[20].to_i
    wikiname = data[21].to_s

    arcana = Arcana.find_by(job_code: code) || Arcana.new
    arcana.name = name
    arcana.title = title
    arcana.arcana_type = arcana_type
    raise "arcana_type not found => #{arcana.name} #{arcana.arcana_type}" unless Arcana::ARCANA_TYPE_NAMES.key?(arcana.arcana_type.to_sym)
    arcana.person_code = person
    arcana.link_code = link
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
    arcana.job_detail = job_detail
    arcana.max_atk = (matk.positive? ? matk : nil)
    arcana.max_hp = (mhp.positive? ? mhp : nil)
    arcana.limit_atk = (latk.positive? ? latk : nil)
    arcana.limit_hp = (lhp.positive? ? lhp : nil)
    arcana.wiki_name = wikiname

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

    # TODO: 特別対応の汎用的なやり方を検討する
    arcana.name = 'セガ・マークⅢ' if arcana.job_code == 'A82'
    arcana.title = '絶✝影' if arcana.job_code == 'A136'

    output_warning "warning : arcana #{arcana.name} : #{arcana.changes}" if arcana.changed?
    if arcana.max_atk.nil? || arcana.max_hp.nil?
      output_warning "warning : arcana #{arcana.name} : lack max_atk/max_hp"
    end

    arcana.save!
    arcana
  end

  def import_skill
    each_data_lines(skill_table_file) do |code, lines|
      arcana = stored_arcanas[code]
      unless arcana
        output_warning "missing arcana for #{code}"
        next
      end

      sks = arcana.skills.sort_by(&:skill_type)
      sk = nil
      efs = []

      # 伝授可能
      inherit = []
      lines.each do |data|
        next if data[1].blank?
        i = data.dup
        i[0] = 'd' if inherit.blank?
        i[4] = ''  unless i[3] == 'forward' # drop condition
        inherit << i
      end
      lines += inherit if inherit.present?

      lines.each.with_index(1) do |data, ord|
        stype = data.shift
        data.shift # drop inherit
        sname = data.shift
        raise "skill: skill_type or name not found => #{arcana.name}" if (stype.present? && sname.blank?) || (stype.blank? && sname.present?)

        if stype.present? && sname.present?
          sk = sks.shift || Skill.new
          sk.job_code = code
          sk.skill_type = stype.to_s
          sk.name = sname
          sk.cost = data.shift.to_i
          arcana.skills << sk if sk.new_record?
          sk.save!

          efs.each(&:destroy) # 余分なのを削除
          efs = sk.skill_effects.sort_by(&:order)

          multi_type = ''
          multi_cond = data.shift.to_s
        else
          next unless sk
          multi_type = data.shift.to_s
          multi_cond = data.shift.to_s
          raise "multi_type not found => #{sk.name}" if multi_type.blank?
          raise "multi_type not found => #{sk.name} #{multi_type}" unless SkillEffect::MULTI_TYPE.key?(multi_type.to_sym)
        end

        ef = efs.shift || SkillEffect.new
        ef.order = ord
        ef.multi_type = multi_type
        ef.multi_condition = multi_cond

        ef.category = data.shift.to_s
        raise "category not found => #{sk.name} #{ef.category}" unless SkillEffect::CATEGORYS.key?(ef.category.to_sym)

        check_table = SkillEffect::CATEGORYS.fetch(ef.category.to_sym, {})
        ef.subcategory = data.shift
        raise "subcategory not found => #{sk.name} #{ef.subcategory}" unless SkillEffect::SUBCATEGORYS.key?(ef.subcategory.to_sym)
        raise "subcategory not defined => #{sk.name} #{ef.category} #{ef.subcategory}" unless check_table.fetch(:sub, {}).fetch(ef.subcategory.to_sym, nil)

        effect_table = check_table.fetch(:effect, {})
        ef.subeffect1 = data.shift.to_s
        if ef.subeffect1.present?
          raise "subeffect1 not found => #{sk.name} #{ef.subeffect1}" unless SkillEffect::SUBEFFECTS.key?(ef.subeffect1.to_sym)
          raise "subeffect1 not defined => #{sk.name} #{ef.category} #{ef.subeffect1}" unless effect_table.fetch(ef.subeffect1.to_sym, nil)
        end
        ef.subeffect2 = data.shift.to_s
        if ef.subeffect2.present?
          raise "subeffect2 not found => #{sk.name} #{ef.subeffect1}" unless SkillEffect::SUBEFFECTS.key?(ef.subeffect2.to_sym)
          raise "subeffect2 not defined => #{sk.name} #{ef.category} #{ef.subeffect2}" unless effect_table.fetch(ef.subeffect2.to_sym, nil)
        end
        ef.subeffect3 = data.shift.to_s
        if ef.subeffect3.present?
          raise "subeffect3 not found => #{sk.name} #{ef.subeffect1}" unless SkillEffect::SUBEFFECTS.key?(ef.subeffect3.to_sym)
          raise "subeffect3 not defined => #{sk.name} #{ef.category} #{ef.subeffect3}" unless effect_table.fetch(ef.subeffect3.to_sym, nil)
        end
        ef.subeffect4 = data.shift.to_s
        if ef.subeffect4.present?
          raise "subeffect4 not found => #{sk.name} #{ef.subeffect1}" unless SkillEffect::SUBEFFECTS.key?(ef.subeffect4.to_sym)
          raise "subeffect4 not defined => #{sk.name} #{ef.category} #{ef.subeffect4}" unless effect_table.fetch(ef.subeffect4.to_sym, nil)
        end
        ef.subeffect5 = data.shift.to_s
        if ef.subeffect5.present?
          raise "subeffect5 not found => #{sk.name} #{ef.subeffect1}" unless SkillEffect::SUBEFFECTS.key?(ef.subeffect5.to_sym)
          raise "subeffect5 not defined => #{sk.name} #{ef.category} #{ef.subeffect5}" unless effect_table.fetch(ef.subeffect5.to_sym, nil)
        end
        ef.note = data.shift.to_s

        output_warning "warning : #{arcana.name} - #{sk.name}(#{sk.skill_type}) : #{ef.changes}" if ef.changed?
        sk.skill_effects << ef if ef.new_record?
        ef.save!
      end
      sks.each(&:destroy) # 余分なのを削除
      efs.each(&:destroy)
    end
  end

  def import_ability
    each_data_lines(ability_table_file) do |code, lines|
      arcana = stored_arcanas[code]
      unless arcana
        output_warning "missing arcana for #{code}"
        next
      end

      abs = arcana.abilities.to_a
      atype = nil
      abi = nil
      efs = []
      eindex = 0
      lines.each do |data|
        at = data.shift
        aname = data.shift
        raise "ability: type or name not found => #{arcana.name}" if (at.present? && at != 'p' && aname.blank?) || (at.blank? && aname.present?)
        eindex += 1
        if at.present? && at != atype
          abi = abs.shift || Ability.new
          abi.job_code = code
          abi.ability_type = at
          abi.name = aname.to_s
          arcana.abilities << abi if abi.new_record?

          atype = at
          eindex = 1
          efs.each(&:destroy) # 余分なのを削除
          efs = abi.ability_effects.sort_by(&:order)
        end

        effect = efs.shift || AbilityEffect.new
        effect.order = eindex
        effect.category = data.shift.to_s
        raise "category not found => #{abi.name} #{effect.category}" unless AbilityEffect::CATEGORYS.key?(effect.category.to_sym)
        effect.condition = data.shift.to_s
        raise "condition not found => #{abi.name} #{effect.condition}" unless AbilityEffect::CONDITIONS.key?(effect.condition.to_sym)
        effect.effect = data.shift.to_s
        raise "effect not found => #{abi.name} #{effect.effect}" unless AbilityEffect::EFFECTS.key?(effect.effect.to_sym)
        effect.target = data.shift.to_s
        raise "target not found => #{abi.name} #{effect.target}" unless AbilityEffect::TARGETS.key?(effect.target.to_sym)
        effect.note = data.shift.to_s

        # 組み合わせチェック
        effcheck = AbilityEffect::CATEGORYS.fetch(effect.category.to_sym, {}).fetch(:effect, {}).fetch(effect.effect.to_sym, nil)
        raise "effect undefined =>  #{abi.name} #{effect.category} #{effect.effect}" unless effcheck
        condcheck = AbilityEffect::CATEGORYS.fetch(effect.category.to_sym, {}).fetch(:condition, {}).fetch(effect.condition.to_sym, nil)
        raise "condition undefined =>  #{abi.name} #{effect.category} #{effect.condition}" unless condcheck
        targetcheck = AbilityEffect::CATEGORYS.fetch(effect.category.to_sym, {}).fetch(:target, {}).fetch(effect.target.to_sym, nil)
        raise "target undefined =>  #{abi.name} #{effect.category} #{effect.target}" unless targetcheck

        output_warning "warning : #{arcana.name} - #{abi.name}(#{abi.ability_type}) : #{effect.changes}" if effect.changed?
        abi.ability_effects << effect if effect.new_record?
        effect.save!

        # 武器名
        wname = data.shift
        abi.weapon_name = wname if wname.present?

        abi.save!
      end
      abs.each(&:destroy) # 余分なのを削除
      efs.each(&:destroy)
    end
  end
end

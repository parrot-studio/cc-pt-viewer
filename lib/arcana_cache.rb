class ArcanaCache
  include RedisCache::Common
  include RedisCache::Cache

  # 同時にredisから取得する件数
  PARALLEL_GET_SIZE = 10

  class << self
    def conditions
      with_object_cache("conditions:#{ServerSettings.data_version}") do
        {
          unions: Arcana::UNION_NAMES.reject { |k, _| k == :unknown }.to_a,
          sourcecategorys: Arcana::SOURCE_CATEGORYS,
          sources: Arcana::SOURCE_CONDS,
          skillcategorys: SkillEffect::CATEGORY_CONDS,
          skillsubs: SkillEffect::SUBCATEGORY_CONDS,
          skilleffects: SkillEffect::SUBEFFECT_CONDS,
          abilitycategorys: AbilityEffect::CATEGORY_CONDS,
          abilityeffects: AbilityEffect::EFFECT_CONDS,
          abilityconditions: AbilityEffect::CONDITION_CONDS,
          chainabilitycategorys: AbilityEffect.chain_ability_categorys,
          chainabilityeffects: AbilityEffect.chain_ability_effects,
          chainabilityconditions: AbilityEffect.chain_ability_conditions,
          voiceactors: VoiceActor.conditions,
          illustrators: Illustrator.conditions,
          latestinfo: Changelog.latest.as_json
        }
      end
    end

    def recently(size = nil)
      size ||= ServerSettings.recently
      with_object_cache("recently:#{ServerSettings.data_version}:#{size}") do
        codes = Arcana.order(Arcana.arel_table[:id].desc).limit(size).distinct.pluck(:job_code)
        for_codes(codes)
      end
    end

    def search_result(query_key)
      key = "search:#{ServerSettings.data_version}:#{query_key}"
      with_object_cache(key) do
        codes = yield
        for_codes(codes)
      end
    end

    def for_codes(codes)
      cs = [codes].flatten.uniq.compact
      return if cs.blank?

      # 少数ずつ分割してpipelineに投げる
      res = []
      cs.each_slice(PARALLEL_GET_SIZE) do |li|
        futures = []
        redis.pipelined do
          li.each do |code|
            futures << redis.get(arcana_cache_key(code))
          end
        end

        # dumpから復元
        futures.each do |f|
          data = f.value
          a = begin
                Marshal.load(data).with_indifferent_access
              rescue
                nil
              end
          res << a if a
        end
      end
      # 数が足りていればそのまま返す
      return sort_cache(cs, res) if res.size == cs.size

      # 足りない分を保管する
      exists = res.map { |d| d['job_code'] }.compact
      lacks = cs - exists
      as = ::Arcana.where(job_code: lacks)
      as.each { |a| res << update_cache(a) } # キャッシュを作成しながら追加

      sort_cache(cs, res)
    end

    def voice_actor_name(id)
      voice_actor_name_table[id]
    end

    def voice_actor_id(name)
      voice_actor_id_table[name]
    end

    def illustrator_name(id)
      illustrator_name_table[id]
    end

    def illustrator_id(name)
      illustrator_id_table[name]
    end

    def rebuild
      clear
      conditions
      Arcana.all.each { |a| update_cache(a) }
      voice_actor_name_table
      voice_actor_id_table
      illustrator_name_table
      illustrator_id_table
      recently
    end

    private

    def arcana_cache_key(code)
      @arcana_key_header ||= "arcanas:#{ServerSettings.data_version}"
      "#{@arcana_key_header}:#{code}"
    end

    def sort_cache(codes, as)
      hash = as.each_with_object({}) { |o, h| h[o['job_code']] = o }
      codes.map { |c| hash[c] }
    end

    def update_cache(arcana)
      return unless arcana
      data = arcana.serialize
      redis.set(arcana_cache_key(arcana.job_code), Marshal.dump(data))
      data.with_indifferent_access
    end

    def voice_actor_name_table
      @voice_actor_name_table ||=
        with_object_cache("#{voice_actor_key_header}:names") do
          create_table_for_name(VoiceActor)
        end
      @voice_actor_name_table
    end

    def voice_actor_id_table
      @voice_actor_id_table ||=
        with_object_cache("#{voice_actor_key_header}:codes") do
          create_table_for_id(VoiceActor)
        end
      @voice_actor_id_table
    end

    def voice_actor_key_header
      @voice_actor_key_header ||= "#{VoiceActor.table_name}:#{ServerSettings.data_version}"
      @voice_actor_key_header
    end

    def illustrator_name_table
      @illustrator_name_table ||=
        with_object_cache("#{illustrator_key_header}:names") do
          create_table_for_name(Illustrator)
        end
      @illustrator_name_table
    end

    def illustrator_id_table
      @illustrator_id_table ||=
        with_object_cache("#{illustrator_key_header}:codes") do
          create_table_for_id(Illustrator)
        end
      @illustrator_id_table
    end

    def illustrator_key_header
      @illustrator_key_header ||= "#{Illustrator.table_name}:#{ServerSettings.data_version}"
      @illustrator_key_header
    end

    def create_table_for_name(clazz)
      clazz.all.each_with_object({}) { |d, h| h[d.id] = d.name }
    end

    def create_table_for_id(clazz)
      clazz.all.each_with_object({}) { |d, h| h[d.name] = d.id }
    end
  end
end

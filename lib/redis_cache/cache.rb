module RedisCache
  module Cache
    extend ActiveSupport::Concern

    class_methods do
      def add_cache(name, val, time = nil)
        if time
          redis.setex(name, time, val)
        else
          redis.set(name, val)
        end
      end

      def add_object_cache(name, val, time = nil)
        add_cache(name, Oj.dump(val), time)
      end

      def read_cache(name)
        redis.get(name)
      end

      def read_object_cache(name)
        val = read_cache(name)
        begin
          val ? Oj.load(val) : nil
        rescue
          nil
        end
      end

      # 文字列のキャッシュ
      def with_cache(name, time = nil)
        val = read_cache(name)
        return val if val.present?
        return unless block_given?

        val = yield
        add_cache(name, val, time)
        val
      end

      # オブジェクトキャッシュ
      def with_object_cache(name, time = nil)
        obj = read_object_cache(name)
        return obj if obj.present?
        return unless block_given?

        obj = yield
        add_object_cache(name, obj, time)
        obj
      end

      # 生のredisインターフェースでキャッシュを操作
      def with_redis
        yield(redis)
      end
    end
  end
end

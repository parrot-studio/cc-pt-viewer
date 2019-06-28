module RedisCache
  module Common
    extend ActiveSupport::Concern

    class_methods do
      def connect!
        config = Settings.redis
        redis = Redis.new(host: config.host, port: config.port, db: config.db)
        @_redis = Redis::Namespace.new("ccpts:#{Rails.env}", redis: redis)
      end

      def connect?
        return false unless redis

        begin
          redis.ping
          true
        rescue
          false
        end
      end

      delegate :keys, to: :redis

      def clear
        redis.redis.flushdb
      end

      def delete(names)
        keys = [names].flatten.compact
        redis.del(keys) if keys.present?
      end

      def delete_keys(query)
        keys = redis.keys(query)
        redis.del(keys) if keys.present?
      end

      private

      def redis
        connect! unless @_redis
        @_redis
      end
    end
  end
end

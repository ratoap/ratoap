require "open3"

module Ratoap
  class ClientConnProgress

    attr_reader :names
    attr_reader :redis

    def initialize(names)
      @names = names

      @redis = Ratoap.redis
    end

    def run
      redis.set "ratoap:client_conn:wait", names.to_json

      i = 0

      r = while i <= 10 do
        i += 1

        wait_conn_client_names = JSON.parse(redis.get("ratoap:client_conn:wait"))
        break 1 if wait_conn_client_names.size == 0

        redis.publish("ratoap:client_conn", JSON.dump({act: :wait, redis_scripts: RedisScript.data}))
        sleep 3
      end

      if r != 1
        redis.publish("ratoap:client_conn", JSON.dump({act: :quit}))
      end
    end

    private


  end
end

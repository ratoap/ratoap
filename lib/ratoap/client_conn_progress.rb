require "open3"

module Ratoap
  class ClientConnProgress

    attr_reader :names
    attr_reader :redis
    attr_reader :main_pid

    def initialize(names)
      @names = names

      @redis = Ratoap.redis
    end

    def run
      redis.set "ratoap:client_conn:wait", names.to_json

      @main_pid = Process.fork do
        while true do
          wait_conn_client_names = JSON.parse(redis.get("ratoap:client_conn:wait"))
          break 1 if wait_conn_client_names.size == 0

          Ratoap.logger.info "publish ratoap:client_conn"

          redis.publish("ratoap:client_conn", JSON.dump({act: :wait, redis_script_shas: RedisScript.data}))
          sleep 3
        end
      end
    end

    def exit
      redis.publish("ratoap:client_conn", JSON.dump({act: :quit}))

      Process.kill("HUP", main_pid)
    end

    private


  end
end

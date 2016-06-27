require 'active_support/core_ext/module'
require 'digest/sha1'

module Ratoap
  class RedisScript

    cattr_accessor :data
    self.data = {}

    def self.load
      dir = File.expand_path('../redis_scripts', __FILE__)

      [:get_conn_identity].each do |script_name|
        file = File.join dir, "ratoap_#{script_name}.lua"

        sha1 = Digest::SHA1.file file
        sha1sum = sha1.hexdigest

        unless Ratoap.redis.script(:exists, sha1sum)
          _sha1sum = Ratoap.redis.script(:load, File.read(file))
          raise 'sha1sum failed' if _sha1sum != sha1sum
        end

        self.data[script_name] = sha1sum
      end
    end

  end
end

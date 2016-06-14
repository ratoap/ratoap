module Ratoap
  class SubProgressLogSynchronizer

    attr_reader :pid
    attr_reader :file

    def initialize(name)
      @name = name
      @file = touch_file

      make_sub_progress

      self
    end

    def make_sub_progress
      @pid = Process.fork do
        writer = File.open(@file, 'r')
        writer.wait_readable
        while true
          if line = writer.gets
            Ratoap.logger.info line
          end
        end
      end
    end

    def exit
      Process.kill("HUP", pid)
    end

    private

    def touch_file
      _file = File.join(Ratoap.workdir, "#{@name}.log")

      FileUtils.rm_rf _file if File.exists?(_file)
      FileUtils.mkdir_p File.basename(_file)
      FileUtils.touch _file
      FileUtils.chmod 0777, _file
      File.truncate _file, 0

      _file
    end

  end
end

require "open3"

module Ratoap
  class ClientProgress

    attr_reader :name, :settings, :log_sync
    attr_reader :main_pid, :log_sync_pid

    def initialize(name, settings)
      @name = name
      @settings = settings
      @log_sync = false
    end

    def enable_log_sync
      touch_log_sync_file
      @log_sync = true
    end

    def run
      return unless settings['auto_run']

      cmd = "ratoap-#{@name}"

      if @log_sync
        cmd += " -l #{log_sync_file}"
      end

      if @log_sync
        @log_sync_pid = Process.fork do
          writer = File.open(log_sync_file, 'r')
          writer.wait_readable
          while true
            if line = writer.gets
              Ratoap.logger.info line
            end
          end
        end
      end

      @main_pid = Process.fork do
        Open3.popen3("#{cmd}") do |stdin, stdout, stderr, wait_thr|
          pid = wait_thr.pid
          exit_status = wait_thr.value
        end
      end
    end

    def exit
      Process.kill("HUP", main_pid)
      Process.kill("HUP", log_sync_pid)
    end

    private

    def touch_log_sync_file
      file = log_sync_file
      FileUtils.rm_rf file if File.exists?(file)
      FileUtils.mkdir_p File.basename(file)
      FileUtils.touch file
      FileUtils.chmod 0777, file
      File.truncate file, 0
    end

    def log_sync_file
      File.join(Ratoap.workdir, "#{name}.log")
    end

  end
end

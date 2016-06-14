module Ratoap
  class SubProgressClient

    attr_reader :pid

    def initialize(cmd)
      @cmd = cmd

      make_sub_progress

      self
    end

    def make_sub_progress
      @pid = Process.fork do
        Open3.popen3("#{@cmd}") do |stdin, stdout, stderr, wait_thr|
          pid = wait_thr.pid
          exit_status = wait_thr.value
        end
      end
    end

    def exit
      Process.kill("HUP", pid)
    end

  end
end

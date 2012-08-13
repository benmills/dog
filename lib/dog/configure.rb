require_relative "command"
require_relative "scheduled_task"

module Dog
  class Configure
    def self.parse config_string
      config = Configure.new
      config.instance_eval config_string
      config
    end

    attr_reader :commands, :scheduled_tasks

    def initialize
      @commands = []
      @scheduled_tasks = []
    end

    def command title
      command = Command.new title
      yield command
      @commands << command
    end

    def task title
      task = ScheduledTask.new title
      yield task
      @scheduled_tasks << task
    end
  end
end

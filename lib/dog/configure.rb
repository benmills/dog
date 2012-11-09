require_relative "command"
require_relative "scheduled_task"

module Dog
  class Configure
    def self.parse config_string
      config = Configure.new
      config.instance_eval config_string
      config
    end

    attr_reader :scheduled_tasks, :chat_rooms

    def initialize
      @commands = {}
      @scheduled_tasks = []
      @chat_rooms = []
    end

    def commands
      @commands.values
    end

    def get_command command_title
      @commands[command_title]
    end

    def command title, &block
      command = @commands.fetch title, Command.new(title)
      command.instance_eval &block
      @commands[title] = command
    end

    def task title
      task = ScheduledTask.new title
      yield task
      @scheduled_tasks << task
    end

    def chat_rooms *chat_rooms
      @chat_rooms += chat_rooms
    end
  end
end

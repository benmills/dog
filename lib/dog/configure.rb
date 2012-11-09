require_relative "command"
require_relative "scheduled_task"

module Dog
  class Configure
    def self.parse_path(config_path)
      parse(_config_string(config_path))
    end

    def self.parse(config_string)
      config = Configure.new
      config.instance_eval(config_string)
      config
    end

    def self._config_string(path)
      return File.read path if File.file? path

      Dir.foreach(path).each_with_object("") do |item, output|
        next if item == '.' or item == '..'
        output << _config_string(File.join(path, item))
      end
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

    def get_command(command_title)
      @commands[command_title]
    end

    def command(title, &block)
      command = @commands.fetch title, Command.new(title)
      command.instance_eval &block
      @commands[title] = command
    end

    def task(title)
      task = ScheduledTask.new(title)
      yield task
      @scheduled_tasks << task
    end

    def chat_rooms(*chat_rooms)
      @chat_rooms += chat_rooms
    end
  end
end

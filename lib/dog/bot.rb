module Dog
  class Bot
    attr_accessor :memory, :commands

    def initialize(connection, config_path)
      @config_path = config_path
      @connection = connection
      @commands = []
      @rooms = []
      @memory = {}
    end

    def process_chat_message(message)
      response = process(message.body)
      say(message.from, response) unless response.nil?
    end

    def process_group_chat_message(message)
      return if _from_self(message) || message.delayed?

      response = process message.body

      say_to_chat(message.from.node, response) unless response.nil?
    end

    def process(message)
      response = respond_to(message)

      if response.is_a?(Symbol)
        respond_to_action(message, response)
      else
        response
      end
    end

    def respond_to(text)
      @commands.each do |command|
        response = command.respond_to text
        return response unless response.nil?
      end

      nil
    end

    def respond_to_action(message, kind)
      case kind
      when :join then
        room_name = message.split.last
        join room_name
        "joined #{room_name}"
      when :reload then
        config
        "config reloaded"
      when :run_task
        title = message.split[3..-1].join(" ")
        return nil if title.empty?
        task = @tasks.find { |t| t.title == title }
        task.run(self) unless task.nil?
      else "invalid action"
      end
    end

    def say(to, message)
      @connection.say(to, message)
    end

    def say_to_chat(to, message)
      @connection.say_to_chat(to, message)
    end

    def say_to_all_chat_rooms(message)
      @rooms.each do |room|
        say_to_chat(room, message)
      end
    end

    def join(*room_names)
      room_names.each do |room_name|
        @connection.join room_name
        @rooms << room_name
      end
    end

    def config
      config = Configure.parse_path(@config_path)

      @commands = config.commands
      @tasks = config.scheduled_tasks
      join(*config.chat_rooms)
    end

    def _from_self(message)
      @rooms.each do |room|
        return true if "#{room}@conference.#{@connection.jid.domain}/#{@connection.jid.node}" == message.from
      end
      false
    end
  end
end

module Dog
  class Bot
    def initialize connection
      @connection = connection
      @commands = []
      @rooms = []
    end

    def process_chat_message message
      response = process message.body
      @connection.say message.from, response unless response.nil?
    end

    def process_group_chat_message message
      return if _from_self(message) || message.delayed?

      response = process message.body
      @connection.say_to_chat message.from.node, response unless response.nil?
    end

    def process message
      response = respond_to message

      if response.is_a? Symbol
        respond_to_action message, response
      else
        response
      end
    end

    def respond_to text
      @commands.each do |command|
        response = command.respond_to text
        return response unless response.nil?
      end

      nil
    end

    def respond_to_action message, kind
      case kind
      when :join then
        room_name = message.split.last
        join room_name
        "joined #{room_name}"
      when :reload then
        config
        "config reloaded"
      else "invalid action"
      end
    end

    def join room_name
      @connection.join room_name
      @rooms << room_name
    end

    def config
      raise "Need 'CONFIG_PATH' env var" unless ENV.has_key? "CONFIG_PATH"

      config = File.read ENV["CONFIG_PATH"]
      @commands = Configure.parse config
    end

    def _from_self message
      @rooms.each do |room|
        return true if "#{room}@conference.#{@connection.jid.domain}/#{@connection.jid.node}" == message.from
      end
      false
    end
  end
end

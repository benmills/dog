require_relative "command"

module Dog
  class Bot
    def initialize connection
      @connection = connection
    end

    def say text
      @connection.say text
    end

    def join room_name
      @connection.join room_name
    end
  end
end

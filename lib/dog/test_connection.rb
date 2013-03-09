module Dog
  class TestConnection
    attr_reader :joined_rooms, :sent_messages

    def initialize(client=nil)
      @joined_rooms = []
      @sent_messages = []
    end

    def join(room_name)
      @joined_rooms << room_name
    end

    def say(to, text)
      @sent_messages << [to, text]
    end

    def say_to_chat(to, text)
      @sent_messages << [to, text]
    end
  end
end

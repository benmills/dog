module Dog
  class Connection
    def initialize say, join, jid
      @say, @join, @jid = say, join, jid
    end

    def jid
      @jid.call
    end

    def join room_name
      @join.call "#{room_name}@conference.#{jid.domain}", jid.node
    end

    def say to, text
      @say.call to, text
    end

    def say_to_chat room_name, text
      to = Blather::JID.new room_name, "conference.#{jid.domain}"
      @say.call to, text, :groupchat
    end
  end
end

module Dog
  class Connection
    def initialize(client)
      @client = client
    end

    def jid
      @client.jid
    end

    def join(room_name)
      room = "#{room_name}@conference.#{jid.domain}"
      service = jid.node

      join_stanza = Blather::Stanza::Presence::MUC.new
      join_stanza.to = "#{room}/#{service}"

      @client.write(join_stanza)
    end

    def say(to, text)
      @client.write(Blather::Stanza::Message.new(to, text, :chat))
    end

    def say_to_chat(room_name, text)
      to = Blather::JID.new(room_name, "conference.#{jid.domain}")
      @client.write(Blather::Stanza::Message.new(to, text, :groupchat))
    end
  end
end

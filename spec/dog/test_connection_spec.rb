require "ostruct"

require "minitest/spec"
require "minitest/autorun"

require_relative "../../lib/dog/test_connection"

describe Dog::TestConnection do
  subject do
    Dog::TestConnection.new
  end

  describe ".join" do
    it "adds the join stanza to a list of joined rooms" do
      subject.join("my_room")
      subject.joined_rooms.must_equal ["my_room"]
    end
  end

  describe ".say" do
    it "adds the message to the sent_messages array" do
      subject.say("bob", "hello world")
      subject.sent_messages.last.must_equal ["bob", "hello world"]
    end
  end

  describe ".say_to_chat" do
    it "adds the message to the sent_messages array" do
      subject.say_to_chat("my_chat", "hello chat world")
      subject.sent_messages.last.must_equal ["my_chat", "hello chat world"]
    end
  end
end

require "minitest/spec"
require "minitest/autorun"
require_relative "../lib/dog.rb"

class FakeConnection
  attr_reader :rooms, :output

  def initialize
    @rooms = []
    @output = []
  end

  def say text
    @output << text
  end

  def join room_name
    @rooms << room_name
  end
end

describe Dog do
  let(:connection) { FakeConnection.new }
  subject { Dog.new(connection) }

  describe ".say" do
    it "delegates to the connection" do
      subject.say "foo bar!"
      connection.output.last.must_equal "foo bar!"
    end
  end

  describe ".join" do
    it "delegates to the connection" do
      subject.join "my_room"
      connection.rooms.last.must_equal "my_room"
    end
  end
end

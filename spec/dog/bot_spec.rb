require "ostruct"
require "minitest/spec"
require "minitest/autorun"

require_relative "../../lib/dog/bot"
require_relative "../../lib/dog/command"
require_relative "../../lib/dog/scheduled_task"
require_relative "../../lib/dog/test_connection"

class Dog::Bot
  def config
    command = Dog::Command.new "greet"
    command.matches "hi"
    command.action { "hello" }
    @commands = [command]

    task = Dog::ScheduledTask.new "my task"
    task.every "4h"
    task.action { "I did it!" }
    @tasks = [task]
  end
end

describe Dog::Bot do
  let(:connection) { Dog::TestConnection.new }
  subject { Dog::Bot.new(connection, "config") }

  before(:each) { subject.config }

  describe ".process_chat_message" do
    it "processes a message that matches" do
      message = OpenStruct.new(:from => "bob", :body => "hi dog")
      subject.process_chat_message(message)

      connection.sent_messages.last.must_equal ["bob", "hello"]
    end

    it "doesn't process a non-matching message" do
      message = OpenStruct.new(:from => "bob", :body => "bad string")
      subject.process_chat_message(message)

      connection.sent_messages.must_be_empty
    end
  end

  describe ".process_group_chat_message" do
    it "processes a group message that matches" do
      message = OpenStruct.new(
        :from => OpenStruct.new(:node => "bob", :domain => "chat"),
        :body => "hi dog",
        :delayed? => false
      )
      subject.process_group_chat_message(message)

      connection.sent_messages.last.must_equal ["bob", "hello"]
    end

    it "doesn't process a non-matching message" do
      message = OpenStruct.new(
        :from => OpenStruct.new(:node => "bob", :domain => "chat"),
        :body => "bad string",
        :delayed? => false
      )
      subject.process_group_chat_message(message)
      connection.sent_messages.must_be_empty
    end
  end

  describe ".respond_to_action" do
    it "joins a room" do
      output = subject.respond_to_action("dog join chatroom", :join)

      output.must_equal "joined chatroom"
      connection.joined_rooms.last.must_equal "chatroom"
    end

    it "reloads" do
      output = subject.respond_to_action("dog reload", :reload)
      output.must_equal "config reloaded"
    end

    it "forces the given task to run" do
      output = subject.respond_to_action("dog run task my task", :run_task)
      output.must_equal "I did it!"
    end
  end

  describe ".join" do
    it "joins a room" do
      subject.join("my_room")
      connection.joined_rooms.last.must_equal "my_room"
    end

    it "can join many rooms" do
      rooms = ["my_room", "my_other_room"]
      subject.join(*rooms)
      connection.joined_rooms.must_equal rooms
    end
  end
end

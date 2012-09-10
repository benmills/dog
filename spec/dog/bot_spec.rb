require "ostruct"
require "minitest/spec"
require "minitest/autorun"

require_relative "../../lib/dog/bot"
require_relative "../../lib/dog/command"

class FakeConnection
  attr_reader :output, :chat_output, :rooms

  def initialize
    @output = []
    @chat_output = []
    @rooms = []
  end

  def say from, response
    @output << [from, response]
  end

  def say_to_chat from, response
    @chat_output << [from, response]
  end

  def join room_name
    @rooms << room_name
  end

  def jid
    OpenStruct.new(
      :jid => OpenStruct.new(:domain => "example.com"),
      :node => "dog"
    )
  end
end

class Dog::Bot
  def config
    command = Dog::Command.new "greet"
    command.matches "hi"
    command.action { "hello" }
    @commands = [command]
  end
end

describe Dog::Bot do
  let(:connection) { FakeConnection.new }
  subject { Dog::Bot.new connection, "config" }

  before(:each) { subject.config }

  describe ".process_chat_message" do
    it "processes a message that matches" do
      message = OpenStruct.new :from => "bob", :body => "hi dog"
      subject.process_chat_message message
      connection.output.last.must_equal ["bob", "hello"]
    end

    it "doesn't process a non-matching message" do
      message = OpenStruct.new :from => "bob", :body => "bad string"
      subject.process_chat_message message
      connection.output.must_be_empty
    end
  end

  describe ".process_group_chat_message" do
    it "processes a message that matches" do
      message = OpenStruct.new(
        :from => OpenStruct.new(:node => "bob", :domain => "chat"),
        :body => "hi dog",
        :delayed? => false
      )
      subject.process_group_chat_message message
      connection.chat_output.last.must_equal ["bob", "hello"]
    end

    it "doesn't process a non-matching message" do
      message = OpenStruct.new(
        :from => OpenStruct.new(:node => "bob", :domain => "chat"),
        :body => "bad string",
        :delayed? => false
      )
      subject.process_group_chat_message message
      connection.chat_output.must_be_empty
    end
  end

  describe ".respond_to_action" do
    it "joins a room" do
      output = subject.respond_to_action "dog join chatroom", :join
      output.must_equal "joined chatroom"
      connection.rooms.last.must_equal "chatroom"
    end

    it "reloads" do
      output = subject.respond_to_action "dog reload", :reload
      output.must_equal "config reloaded"
    end
  end
end

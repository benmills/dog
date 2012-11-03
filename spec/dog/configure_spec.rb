require "minitest/spec"
require "minitest/autorun"
require_relative "../../lib/dog/configure.rb"

describe Dog::Configure do
  let :config_string do
<<CONFIG
command "greet" do
  matches "hello", "hi", "whats up"
  action { "hello!" }

  subcommand "cool greet" do
    matches "yo"
    action { "yo yo yo, hello!" }
  end
end

task "say hi" do |t|
  t.every "1m"
  t.action { "hello!" }
end

chat_rooms "test_room", "test_room2"
CONFIG
  end

  describe "#parse" do
    it "parses a string into an array of commands" do
      config = Dog::Configure.parse config_string
      command = config.commands.first

      command.respond_to("hi").must_equal "hello!"
      command.respond_to("hello").must_equal "hello!"
      command.respond_to("whats up").must_equal "hello!"
    end

    it "parses subcommands" do
      config = Dog::Configure.parse config_string
      command = config.commands.first

      command.respond_to("hi yo").must_equal "yo yo yo, hello!"
    end

    it "parses a string into an array of scheduled tasks" do
      config = Dog::Configure.parse config_string
      task = config.scheduled_tasks.first

      task.run({}).must_equal "hello!"
      task.frequency.must_equal "1m"
    end

    it "parses default chat rooms from a config string" do
      config = Dog::Configure.parse config_string

      config.chat_rooms.first.must_equal "test_room"
    end

    it "parses multiple chat rooms from a config string" do
      config = Dog::Configure.parse config_string

      config.chat_rooms.must_equal ["test_room", "test_room2"]
    end
  end
end

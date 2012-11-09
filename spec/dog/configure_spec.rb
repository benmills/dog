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

command "dog" do
  matches "dog"

  subcommand "pet" do
    matches "pet"
    action { "*wags tail*" }
  end
end

command "dog" do
  matches "dog"

  subcommand "fetch" do
    matches "fetch"
    action { "*runs and fetches*" }
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
      command = config.get_command "greet"

      command.respond_to("hi").must_equal "hello!"
      command.respond_to("hello").must_equal "hello!"
      command.respond_to("whats up").must_equal "hello!"
    end

    it "parses subcommands" do
      config = Dog::Configure.parse config_string
      command = config.get_command "greet"

      command.respond_to("hi yo").must_equal "yo yo yo, hello!"
    end

    it "parses subcommands into one top level command from many config entries" do
      config = Dog::Configure.parse config_string
      command = config.get_command "dog"

      command.respond_to("dog pet").must_equal "*wags tail*"
      command.respond_to("dog fetch").must_equal "*runs and fetches*"
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

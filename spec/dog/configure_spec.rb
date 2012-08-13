require "minitest/spec"
require "minitest/autorun"
require_relative "../../lib/dog/configure.rb"

describe Dog::Configure do
  let :command_config_string do
<<CONFIG
command "greet" do |c|
  c.matches "hello", "hi", "whats up"
  c.action { "hello!" }

  c.subcommand "cool greet" do |subcommand|
    subcommand.matches "yo"
    subcommand.action { "yo yo yo, hello!" }
  end
end
CONFIG
  end

  let :task_config_string do
<<CONFIG
task "say hi" do |t|
  t.every "1m"
  t.action { "hello!" }
end
CONFIG
  end

  describe "#parse" do
    it "parses a string into an array of commands" do
      config = Dog::Configure.parse command_config_string
      command = config.commands.first

      command.respond_to("hi").must_equal "hello!"
      command.respond_to("hello").must_equal "hello!"
      command.respond_to("whats up").must_equal "hello!"
    end

    it "parses subcommands" do
      config = Dog::Configure.parse command_config_string
      command = config.commands.first

      command.respond_to("hi yo").must_equal "yo yo yo, hello!"
    end

    it "parses a string into an array of scheduled tasks" do
      config = Dog::Configure.parse task_config_string
      task = config.scheduled_tasks.first

      task.run.must_equal "hello!"
      task.frequency.must_equal "1m"
    end
  end
end

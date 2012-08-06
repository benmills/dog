require "minitest/spec"
require "minitest/autorun"
require_relative "../lib/configure.rb"

describe Configure do
  let :config_string do
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

  describe "#parse" do
    it "parses a string into an array of commands" do
      commands = Configure.parse config_string
      command = commands.first

      command.respond_to("hi").must_equal "hello!"
      command.respond_to("hello").must_equal "hello!"
      command.respond_to("whats up").must_equal "hello!"
    end

    it "parses subcommands" do
      commands = Configure.parse config_string
      command = commands.first

      command.respond_to("hi yo").must_equal "yo yo yo, hello!"
    end
  end
end

require "minitest/spec"
require "minitest/autorun"
require_relative "../../lib/dog/command.rb"

describe Dog::Command do
  subject do
    command = Dog::Command.new "Greet"
    command.matches "hello"
    command.action { "hi" }
    command
  end

  describe ".action" do
    it "sets the action of the command" do
      subject.action { "new action" }
      subject.respond_to("hello").must_equal "new action"
    end

    it "passes the body of the incoming text to the action" do
      subject.action { |body| body }
      subject.respond_to("hello foobarbaz1").must_equal "hello foobarbaz1"
    end
  end

  describe ".matches" do
    it "adds a matcher to the command" do
      subject.matches "foo"
      subject.respond_to("foo").must_equal "hi"
    end

    it "can be called multiple times" do
      subject.matches "foo"
      subject.matches "bar"

      subject.respond_to("foo").must_equal "hi"
      subject.respond_to("bar").must_equal "hi"
    end
  end

  describe ".respond_to" do
    it "calls it's block if the input string matches a matcher" do
      subject.respond_to("hello").must_equal "hi"
    end

    it "calls it's block if a matcher matches a multi-word input string" do
      subject.respond_to("hello dog!").must_equal "hi"
    end

    it "returns nil if no matcher maches" do
      subject.respond_to("bad input").must_be_nil
    end
  end

  describe ".subcommand" do
    it "adds a subcommand" do
      subject.subcommand "cool greet" do |subcommand|
        subcommand.matches "yo"
        subcommand.action { "yo yo yo hello!" }
      end

      subject.respond_to("hello yo").must_equal "yo yo yo hello!"
    end
  end
end

require "minitest/spec"
require "minitest/autorun"
require_relative "../../lib/dog/scheduled_task.rb"

describe Dog::ScheduledTask do
  subject { Dog::ScheduledTask.new "my task" }

  describe ".every" do
    it "sets the frequency of the task" do
      subject.every "1m"
      subject.frequency.must_equal "1m"
    end
  end

  describe ".action" do
    it "sets the action of the task" do
      subject.action { "my action" }
      subject.run.must_equal "my action"
    end
  end
end

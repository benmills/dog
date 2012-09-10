require "minitest/spec"
require "minitest/autorun"

require_relative "../../lib/dog/brain"

describe Dog::Brain do
  subject { Dog::Brain.new :foo => :bar }

  it "can be created without inital data" do
    brain = Dog::Brain.new
    brain.get(:foo).must_be_nil
  end

  describe "get" do
    it "gets a value for a key" do
      subject.get(:foo).must_equal :bar
    end

    it "gets nil for an unknown key" do
      subject.get(:bad_key).must_be_nil
    end
  end

  describe "set" do
    it "sets a key to a value" do
      subject.set(:baz, :foz)
      subject.get(:baz).must_equal :foz
    end

    it "can overwrite existing values" do
      subject.set(:foo, :baz)
      subject.get(:foo).must_equal :baz
    end
  end
end

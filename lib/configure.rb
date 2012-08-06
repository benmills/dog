require_relative "command"

class Configure
  def self.parse config_string
    configurer = Configure.new
    configurer.instance_eval config_string
    configurer.commands
  end

  attr_reader :commands

  def initialize
    @commands = []
  end

  def command title
    command = Command.new title
    yield command
    @commands << command
  end
end

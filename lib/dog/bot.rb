require 'rubygems'
require 'rufus/scheduler'

module Dog
  class Bot
    def initialize connection, config_path
      @config_path = config_path
      @connection = connection
      @commands = []
      @rooms = []
      @brain = Brain.new
    end

    def process_chat_message message
      response = process message.body
      @connection.say message.from, response unless response.nil?
    end

    def process_group_chat_message message
      return if _from_self(message) || message.delayed?

      response = process message.body
      @connection.say_to_chat message.from.node, response unless response.nil?
    end

    def process message
      response = respond_to message

      if response.is_a? Symbol
        respond_to_action message, response
      else
        response
      end
    end

    def respond_to text
      @commands.each do |command|
        response = command.respond_to text
        return response unless response.nil?
      end

      nil
    end

    def respond_to_action message, kind
      case kind
      when :join then
        room_name = message.split.last
        join room_name
        "joined #{room_name}"
      when :reload then
        config
        "config reloaded"
      else "invalid action"
      end
    end

    def join room_name
      @connection.join room_name
      @rooms << room_name
    end

    def config
      config = Configure.parse config_string

      @commands = config.commands
      @scheduled_tasks = config.scheduled_tasks

      config.chat_rooms.each { |chat_room| join chat_room }
      schedule_tasks
    end

    def config_string(path=@config_path)
      return File.read path if File.file? path

      Dir.foreach(path).each_with_object("") do |item, output|
        next if item == '.' or item == '..'
        output << config_string(File.join(path, item))
      end
    end

    def schedule_tasks
      @scheduler.stop unless @scheduler.nil?

      @scheduler = Rufus::Scheduler.start_new

      @scheduled_tasks.each do |task|
        @scheduler.every task.frequency do
          response = task.run self
          next if response.nil?

          @rooms.each do |room|
            @connection.say_to_chat room, response
          end
        end
      end
    end

    def _from_self message
      @rooms.each do |room|
        return true if "#{room}@conference.#{@connection.jid.domain}/#{@connection.jid.node}" == message.from
      end
      false
    end
  end
end

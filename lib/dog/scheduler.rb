require 'rubygems'
require 'rufus/scheduler'

module Dog
  class Scheduler
    def initialize(bot)
      @bot = bot
    end

    def schedule_tasks(scheduled_tasks)
      restart

      scheduled_tasks.each do |task|
        @scheduler.every(task.frequency) do
          if response = task.run(self)
            @bot.say_to_all_chat_rooms(response)
          end
        end
      end
    end

    def restart
      @scheduler.stop unless @scheduler.nil?
      @scheduler = Rufus::Scheduler.start_new
    end
  end
end

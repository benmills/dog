module Dog
  class ScheduledTask
    attr_reader :frequency, :title

    def initialize(title)
      @title = title
    end

    def every(frequency)
      @frequency = frequency
    end

    def action(&block)
      @action = block
    end

    def run(context)
      @action.call(context)
    end
  end
end

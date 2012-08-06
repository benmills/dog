module Dog
  class Command
    def initialize title
      @title = title
      @matchers = []
      @subcommands = []
      @action = -> { }
    end

    def action &action
      @action = action
    end

    def matches *matchers
      @matchers += matchers
    end

    def matches? input_string
      @matchers.any? { |matcher| input_string.match matcher }
    end

    def subcommand title
      subcommand = Command.new title
      yield subcommand
      @subcommands << subcommand
    end

    def subcommand_response input_string
      @subcommands.each do |subcommand|
        response = subcommand.respond_to input_string
        return response unless response.nil?
      end

      nil
    end

    def respond_to input_string
      if matches? input_string
        subcommand_response(input_string) || @action.call
      end
    end
  end
end

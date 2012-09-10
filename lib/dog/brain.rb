module Dog
  class Brain
    def initialize data={}
      @data = data
    end

    def get key
      @data[key]
    end

    def set key, value
      @data[key] = value
    end
  end
end

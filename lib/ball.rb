class Ball
  attr_reader :x, :y

  def initialize(options=nil)
    @x = @y = 0
    if options
      @x = options[:x] 
      @y = options[:y]
    end
  end
end

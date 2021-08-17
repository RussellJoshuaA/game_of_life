class Cell
  attr_reader :x, :y
  attr_accessor :alive

  def initialize(x, y)
    @x, @y = x, y
    @alive = false
  end

end
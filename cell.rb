class Cell
  attr_reader :x, :y

  def initialize(x, y, world)
    @x, @y = x, y
    @world = world
  end

  def neighbor_count
    @world.neighbors_of(@x, @y).count
  end

end
class World

  def initialize
    @cells = [
      Cell.new(0, 0, self)
    ]
  end

  def neighbors_of(x, y)
    @cells.select { |cell| (0..1).include?((x - cell.x).abs) && (0..1).include?((y - cell.y).abs) }
  end

  def step
    @new_cells = []
    @cells.each do |cell|

    end
  end

end
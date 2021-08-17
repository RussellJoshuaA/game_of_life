class Grid
  attr_accessor :rows, :columns

  CELL_WIDTH = 16
  CELL_HEIGHT = 16
  LEFT_PAD = 200
  TOP_PAD = 10

  def initialize(rows, columns)
    @rows, @columns = rows, columns
  end

end
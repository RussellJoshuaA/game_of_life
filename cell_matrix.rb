class CellMatrix
  attr_reader :iteration, :cells

  def initialize(grid)
    @iteration = 0
    @grid = grid
    @cells = [[]]
  end

  def update
    trim_cells
    generate_cells
    @iteration += 1
  end

  def cell_at(x, y)
    x, y = x - Grid::LEFT_PAD, y - Grid::TOP_PAD
    x = x - (x % Grid::CELL_WIDTH)
    y = y - (y % Grid::CELL_HEIGHT)
    @cells.flatten.find { |cell| cell.x == x && cell.y == y }
  end

  def trim_cells
    @cells = @cells[0..@grid.rows]
    @cells.each_with_index do |row, i|
      @cells[i] = row[0..@grid.columns]
    end
  end

  def generate_cells
    (0..@grid.rows).each do |row|
      @cells[row] ||= []
      (0..@grid.columns).each do |column|
        @cells[row][column] ||= Cell.new(Grid::CELL_WIDTH * column, Grid::CELL_HEIGHT * row)
      end
    end
  end

end
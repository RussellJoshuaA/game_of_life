class CellMatrix
  attr_reader :iteration, :cells

  def initialize(grid)
    @iteration = 0
    @grid = grid
    @cells = []
  end

  def update
    # the following are removed temporarily
    # trim_cells
    # generate_cells
    update_cells

    @iteration += 1
  end

  def reset
    @cells = []
    generate_cells
  end

  def cell_at(x, y, relative = false)
    unless relative
      x, y = x - Grid::LEFT_PAD, y - Grid::TOP_PAD
      x = x - (x % Grid::CELL_WIDTH)
      y = y - (y % Grid::CELL_HEIGHT)
    end
    @cells.find { |cell| cell.x == x && cell.y == y }
  end

  def trim_cells
    @cells = @cells[0..@grid.rows]
    @cells.each_with_index do |row, i|
      @cells[i] = row[0..@grid.columns]
    end
  end

  def generate_cells
    (0..@grid.rows).each do |row|
      (0..@grid.columns).each do |column|
        @cells << Cell.new(Grid::CELL_WIDTH * column, Grid::CELL_HEIGHT * row)
      end
    end
  end

  def update_cells
    new_cells = []
    @cells.each do |cell|
      neighbors = [
        cell_at(cell.x - Grid::CELL_WIDTH, cell.y - Grid::CELL_HEIGHT, true),
        cell_at(cell.x, cell.y - Grid::CELL_HEIGHT, true),
        cell_at(cell.x + Grid::CELL_WIDTH, cell.y - Grid::CELL_HEIGHT, true),
        cell_at(cell.x - Grid::CELL_WIDTH, cell.y, true),
        cell_at(cell.x + Grid::CELL_WIDTH, cell.y, true),
        cell_at(cell.x - Grid::CELL_WIDTH, cell.y + Grid::CELL_HEIGHT, true),
        cell_at(cell.x, cell.y + Grid::CELL_HEIGHT, true),
        cell_at(cell.x + Grid::CELL_WIDTH, cell.y + Grid::CELL_HEIGHT, true),
      ]
      live_neighbors = neighbors.select { |cell| cell && cell.alive }

      new_cell = Cell.new(cell.x, cell.y)
      if cell.alive
        if (2..3).include? live_neighbors.count
          new_cell.alive = true
        else
          new_cell.alive = false
        end
      else
        new_cell.alive = true if live_neighbors.count == 3
      end
      new_cells << new_cell
    end

    @cells = new_cells
  end

end
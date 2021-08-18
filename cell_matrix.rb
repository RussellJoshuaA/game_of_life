class CellMatrix
  attr_reader :iteration, :cells

  def initialize(grid)
    @iteration = 0
    @grid = grid
    @cells = []
  end

  def update
    update_cells

    @iteration += 1
  end

  def cell_at(x, y)
    x_index = ((x - Grid::LEFT_PAD) / Grid::CELL_WIDTH).to_i
    y_index = ((y - Grid::TOP_PAD) / Grid::CELL_HEIGHT).to_i
    @cells[x_index][y_index]
  end

  def activate_cell(x, y)
    column_index = ((x - Grid::LEFT_PAD) / Grid::CELL_WIDTH).to_i
    row_index = ((y - Grid::TOP_PAD) / Grid::CELL_HEIGHT).to_i
    @cells[row_index][column_index] = true
  end

  def deactivate_cell(x, y)
    column_index = ((x - Grid::LEFT_PAD) / Grid::CELL_WIDTH).to_i
    row_index = ((y - Grid::TOP_PAD) / Grid::CELL_HEIGHT).to_i
    @cells[row_index][column_index] = false
  end

  def reset
    (0..@grid.rows).each do |row|
      @cells[row] ||= []
      (0..@grid.columns).each do |column|
        @cells[row][column] = false
      end
    end
    @iteration = 0
  end

  def update_cells
    new_values = []
    (0..@grid.rows).each do |row_index|
      new_values[row_index] ||= []
      (0..@grid.columns).each do |column_index|
        neighbors = []
        neighbors << @cells[row_index - 1][column_index - 1] unless row_index == 0 || column_index == 0
        neighbors << @cells[row_index - 1][column_index] unless row_index == 0
        neighbors << @cells[row_index - 1][column_index + 1] unless row_index == 0
        neighbors << @cells[row_index][column_index - 1] unless column_index == 0
        neighbors << @cells[row_index][column_index + 1]
        neighbors << @cells[row_index + 1][column_index - 1] unless row_index == @grid.rows || column_index == 0
        neighbors << @cells[row_index + 1][column_index] unless row_index == @grid.rows
        neighbors << @cells[row_index + 1][column_index + 1] unless row_index == @grid.rows
        neighbor_count = neighbors.count { |neighbor| neighbor == true }

        if @cells[row_index][column_index] == true
          if (2..3).include? neighbor_count
            new_values[row_index][column_index] = true
          else
            new_values[row_index][column_index] = false
          end
        else
          if neighbor_count == 3
            new_values[row_index][column_index] = true
          else
            new_values[row_index][column_index] = false
          end
        end

      end

    end

    @cells = new_values
  end

end
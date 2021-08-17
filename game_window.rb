class GameWindow < Gosu::Window

  def initialize
    super(1024, 768, false)
    self.caption = 'Game Window'

    @grid = Grid.new(46, 44)

    @title_font = Gosu::Font.new(32)
    @controls_font = Gosu::Font.new(24)

    @cell_matrix = CellMatrix.new(@grid)
    @cell_matrix.generate_cells

    @auto_play = false
  end

  def update
    @cell_matrix.update if @auto_play
  end

  def draw
    draw_title
    draw_controls
    draw_info

    draw_grid
    if grid_mouseover
      mouseover_x = (mouse_x - ((mouse_x - Grid::LEFT_PAD) % Grid::CELL_WIDTH))
      mouseover_y = (mouse_y - ((mouse_y - Grid::TOP_PAD) % Grid::CELL_HEIGHT))
      draw_rect(mouseover_x, mouseover_y, Grid::CELL_WIDTH, Grid::CELL_HEIGHT, Gosu::Color::WHITE)
    end

    draw_cells
  end

  def button_down(btn_code)
    @cell_matrix.reset if btn_code == Gosu::KB_ESCAPE

    # the following are removed temporarily
    # case btn_code
    # when Gosu::KB_RIGHT_BRACKET
    #   @grid.columns = (@grid.columns + 1)
    #   @cell_matrix.generate_cells
    #   @cell_matrix.trim_cells
    # when Gosu::KB_LEFT_BRACKET
    #   @grid.columns = (@grid.columns - 1)
    #   @cell_matrix.generate_cells
    #   @cell_matrix.trim_cells
    # when Gosu::KB_EQUALS
    #   @grid.rows = (@grid.rows + 1)
    #   @cell_matrix.generate_cells
    #   @cell_matrix.trim_cells
    # when Gosu::KB_MINUS
    #   @grid.rows = (@grid.rows - 1)
    #   @cell_matrix.generate_cells
    #   @cell_matrix.trim_cells
    # end

    if grid_mouseover
      if btn_code == Gosu::MS_LEFT
        @cell_matrix.cell_at(mouse_x, mouse_y).alive = true
      elsif btn_code == Gosu::MS_RIGHT
        @cell_matrix.cell_at(mouse_x, mouse_y).alive = false
      end
    end

    if btn_code == Gosu::KB_SPACE
      @auto_play = !@auto_play
    elsif btn_code == Gosu::KB_RETURN
      @cell_matrix.update
    end
  end

  def needs_cursor?
    true
  end

  private

  def draw_grid
    (0..(@grid.columns + 1)).each do |c|
      column_x = (c * Grid::CELL_WIDTH) + Grid::LEFT_PAD
      draw_line(
        column_x, Grid::TOP_PAD, Gosu::Color::WHITE,
        column_x, Grid::TOP_PAD + grid_height + Grid::CELL_WIDTH, Gosu::Color::WHITE
      )
    end
    (0..(@grid.rows + 1)).each do |row|
      row_y = (row * Grid::CELL_HEIGHT) + Grid::TOP_PAD
      draw_line(
        Grid::LEFT_PAD + 0, row_y, Gosu::Color::WHITE,
        Grid::LEFT_PAD + grid_width + Grid::CELL_HEIGHT, row_y, Gosu::Color::WHITE
      )
    end

  end

  def grid_height
    @grid.rows * Grid::CELL_HEIGHT
  end

  def grid_width
    @grid.columns * Grid::CELL_WIDTH
  end

  def grid_right
    Grid::LEFT_PAD + grid_width + Grid::CELL_WIDTH
  end

  def grid_bottom
    Grid::TOP_PAD + grid_height + Grid::CELL_HEIGHT
  end

  def grid_mouseover
    (Grid::LEFT_PAD...grid_right).include?(mouse_x) && (Grid::TOP_PAD...grid_bottom).include?(mouse_y)
  end

  def draw_title
    @title_font.draw_text('Game Of Life', 8, 8, 0)
  end

  def draw_controls
    @controls_font.draw_text('Play/Pause: Space', 8, 48, 0)
    @controls_font.draw_text('Next Iteration: Enter', 8, 72, 0)
    @controls_font.draw_text('Activate Cell: Left Click', 8, 96, 0)
    @controls_font.draw_text('Deactivate Cell: Right Click', 8, 120, 0)
  end

  def draw_info
    @controls_font.draw_text("Iteration: #{@cell_matrix.iteration}", 8, 152, 0)
  end

  def draw_cells
    @cell_matrix.cells.each do |cell|
      cell_x = Grid::LEFT_PAD + cell.x
      cell_y = Grid::TOP_PAD + cell.y
      draw_rect(cell_x, cell_y, Grid::CELL_WIDTH, Grid::CELL_HEIGHT, Gosu::Color::GREEN, -10) if cell.alive
    end
  end

end
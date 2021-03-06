class GameWindow < Gosu::Window

  def initialize
    super(1024, 768, false)
    self.caption = 'Game Window'

    @grid = Grid.new(46, 44)

    @title_font = Gosu::Font.new(32)
    @controls_font = Gosu::Font.new(24)

    @cell_matrix = CellMatrix.new(@grid)
    @cell_matrix.reset

    @auto_play = false
    @speed = 100
    @cooldown = 100
  end

  def update
    if @auto_play
      if @speed == 100
        @cell_matrix.update
      else
        if @cooldown <= 0
          @cell_matrix.update
          @cooldown = 96 - @speed
        else
          @cooldown -= 1
        end
      end
    end
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
    if btn_code == Gosu::KB_ESCAPE
      @cell_matrix.reset
      @auto_play = false
    end

    if grid_mouseover
      if btn_code == Gosu::MS_LEFT
        @cell_matrix.activate_cell(mouse_x, mouse_y)
      elsif btn_code == Gosu::MS_RIGHT
        @cell_matrix.deactivate_cell(mouse_x, mouse_y)
      end
    end

    if btn_code == Gosu::KB_SPACE
      @auto_play = !@auto_play
    elsif btn_code == Gosu::KB_RETURN
      @cell_matrix.update
    end

    if btn_code == Gosu::KB_S
      @cell_matrix.quick_save
    elsif btn_code == Gosu::KB_L
      @cell_matrix.quick_load
    end

    case btn_code
    when Gosu::KB_0
      @speed = 100
    when Gosu::KB_9
      @speed = 90
    when Gosu::KB_8
      @speed = 80
    when Gosu::KB_7
      @speed = 70
    when Gosu::KB_6
      @speed = 60
    when Gosu::KB_5
      @speed = 50
    when Gosu::KB_4
      @speed = 40
    when Gosu::KB_3
      @speed = 30
    when Gosu::KB_2
      @speed = 20
    when Gosu::KB_1
      @speed = 10
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
    @controls_font.draw_text('Activate Cell: Left Click', 8, 48, 0)
    @controls_font.draw_text('Deactivate Cell: Right Click', 8, 72, 0)

    @controls_font.draw_text('Play/Pause: Space', 8, 104, 0)
    @controls_font.draw_text('Next Iteration: Enter', 8, 128, 0)
    @controls_font.draw_text('Reset: Esc', 8, 152, 0)
    @controls_font.draw_text('Quick Save/Load: S / L', 8, 176, 0)
    @controls_font.draw_text('Adjust Speed: 1, 2, 3... 9, 0', 8, 200, 0)
  end

  def draw_info
    @controls_font.draw_text("Iteration: #{@cell_matrix.iteration}", 8, 232, 0)
    @controls_font.draw_text("Speed: #{@speed}", 8, 256, 0)
  end

  def draw_cells
    (0..@grid.rows).each do |row_index|
      (0..@grid.columns).each do |column_index|
        if @cell_matrix.cells[row_index][column_index]
          cell_x = Grid::LEFT_PAD + column_index * Grid::CELL_WIDTH
          cell_y = Grid::TOP_PAD + row_index * Grid::CELL_HEIGHT
          draw_rect(cell_x, cell_y, Grid::CELL_WIDTH, Grid::CELL_HEIGHT, Gosu::Color::GREEN, -10)
        end
      end
    end
  end

end
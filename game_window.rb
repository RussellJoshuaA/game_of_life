class GameWindow < Gosu::Window

  GRID_CELL_WIDTH = 16
  GRID_CELL_HEIGHT = 16
  GRID_LEFT_PAD = 200
  GRID_TOP_PAD = 10

  def initialize
    super(1024, 768, false)
    self.caption = 'Game Window'

    @grid_cols = 40
    @grid_rows = 37

    @title_font = Gosu::Font.new(32)
    @controls_font = Gosu::Font.new(24)

    @cell_matrix = CellMatrix.new
  end

  def update

  end

  def draw
    draw_title
    draw_controls

    draw_grid
    if grid_mouseover
      mouseover_x = (mouse_x - ((mouse_x - GRID_LEFT_PAD) % GRID_CELL_WIDTH))
      mouseover_y = (mouse_y - ((mouse_y - GRID_TOP_PAD) % GRID_CELL_HEIGHT))
      draw_rect(mouseover_x, mouseover_y, GRID_CELL_WIDTH, GRID_CELL_HEIGHT, Gosu::Color::WHITE)
    end

    draw_cells
  end

  def button_down(btn_code)
    self.close if btn_code == Gosu::KB_ESCAPE

    @grid_cols += 1 if btn_code == Gosu::KB_RIGHT_BRACKET
    @grid_cols -= 1 if btn_code == Gosu::KB_LEFT_BRACKET
    @grid_rows += 1 if btn_code == Gosu::KB_EQUALS
    @grid_rows -= 1 if btn_code == Gosu::KB_MINUS
  end

  def needs_cursor?
    true
  end

  private

  def draw_grid
    (0..@grid_cols).each do |c|
      column_x = (c * GRID_CELL_WIDTH) + GRID_LEFT_PAD
      draw_line(
        column_x, GRID_TOP_PAD, Gosu::Color::WHITE,
        column_x, GRID_TOP_PAD + grid_height, Gosu::Color::WHITE
      )
    end
    (0..@grid_rows).each do |row|
      row_y = (row * GRID_CELL_HEIGHT) + GRID_TOP_PAD
      draw_line(
        GRID_LEFT_PAD + 0, row_y, Gosu::Color::WHITE,
        GRID_LEFT_PAD + grid_width, row_y, Gosu::Color::WHITE
      )
    end

  end

  def grid_height
    @grid_rows * GRID_CELL_HEIGHT
  end

  def grid_width
    @grid_cols * GRID_CELL_WIDTH
  end

  def grid_right
    GRID_LEFT_PAD + grid_width
  end

  def grid_bottom
    GRID_TOP_PAD + grid_height
  end

  def grid_mouseover
    (GRID_LEFT_PAD...grid_right).include?(mouse_x) && (GRID_TOP_PAD...grid_bottom).include?(mouse_y)
  end

  def draw_title
    @title_font.draw_text('Game Of Life', 8, 8, 0)
  end

  def draw_controls
    @controls_font.draw_text('Play/Pause: Space', 8, 48, 0)
    @controls_font.draw_text('Grid Width: { / }', 8, 72, 0)
    @controls_font.draw_text('Grid Height: - / +', 8, 96, 0)
  end

  def draw_cells
    @cell_matrix.cells.each do |cell_row|
      cell_row.each do |cell|
        cell_x = GRID_LEFT_PAD + cell.x
        cell_y = GRID_TOP_PAD + cell.y
        draw_rect(cell_x, cell_y, GRID_CELL_WIDTH, GRID_CELL_HEIGHT, Gosu::Color::GREEN)
      end
    end
  end

end
require 'gosu'
require_relative "cells"


class Life < Gosu::Window
  attr_writer :state
  SCREEN_HEIGHT = 1200
  SCREEN_WIDTH = 1200

  def initialize
    super(SCREEN_WIDTH, SCREEN_HEIGHT, false)
    @background = Gosu::Image.new(self, 'field.png')
    @cell = Gosu::Image.new(self, 'cell.png')
    @grid = Cells.new(25, 25)
    @zoom = 0
    @state = :building
    @large_font = Gosu::Font.new(self, "Arial", SCREEN_HEIGHT / 20)
    @interval = 0.0
  end

  def draw
    @background.draw(0, 0, 0, (SCREEN_WIDTH/@background.width)*1.1, (SCREEN_HEIGHT/@background.height)*1.1)
    @grid.living.each do |cell|
      draw_cell(cell[0],cell[1])
    end

    if @state == :dead
      draw_text(2, 10, "No more cells living, space to repopulate.", @large_font, 0xfffd7e005)
    end

  end

  def iteration_time(time_second=0)
    t = (time_second > 0) ? time_second : 0
    sleep(t)
    @grid.propagate
  end

  def button_down(key)
    case key
    when Gosu::MsLeft
      if @state == :building
        row, col = get_coords(mouse_x, mouse_y)
        @grid.toggle(row, col)
      end

    when Gosu::KbEscape
      close

    when Gosu::KbLeft
      @interval -= 0.1 unless @interval == 0
    when Gosu::KbRight
      @interval += 0.1

    when Gosu::KbSpace
      if @state == :building
        @state = :running
      else
        @state = :building
      end

    when Gosu::KbUp
      @zoom += 1 unless @zoom == zoom_level.size - 1
    when Gosu::KbDown
      @zoom -= 1 unless @zoom == 0

    when Gosu::KbC
      if @state == :running
        @state = :building
      end
      @grid.clear_board
    end
  end

  def needs_cursor?
    true
  end

  def update
    if @state == :running
      iteration_time(@interval)
      @state = :dead if @grid.living.empty?
    end
  end

  def zoom_level
    #cell needs grid to be accessible.  Expand the boundaries of cell.
    #overwrite current grid -> center of new bounds.
    #25  30  40   50   62   125
    [1, 0.8, 0.6, 0.5, 0.4, 0.2]
  end

  def draw_text(row, col, text, font, color)
    coords = coords_to_px(row, col)
    font.draw(text, coords[0], coords[1], 3, 1, 1, color)
  end

  def draw_cell(row, col)
    coords = coords_to_px(row, col)
    @cell.draw(coords[0], coords[1], 1, 0.9*zoom_level[@zoom], 0.9*zoom_level[@zoom])
  end

  def width
    max_y = SCREEN_HEIGHT / @grid.row_size
    max_x = SCREEN_WIDTH / @grid.col_size
    return max_x > max_y ? max_y : max_x
  end

  def coords_to_px(row, col)
    x = (row-1) * width
    y = (col-1) * width
    [x,y]
  end

  def get_coords(y, x)
    col = (x/width).to_i + 1
    row = (y/width).to_i + 1
    return [row, col]
  end

end

life = Life.new
life.show

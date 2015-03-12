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
    @state = :building
    @large_font = Gosu::Font.new(self, "Arial", SCREEN_HEIGHT / 20)
  end

  def draw
    @background.draw(0, 0, 0, SCREEN_WIDTH/@background.width, SCREEN_HEIGHT/@background.height)
    (1..@grid.row_size).each do |i|
      (1..@grid.col_size).each do |j|

        draw_cell(i, j) if @grid.alive[i][j]
      end
    end

    if @state == :dead
      draw_text(10, 10, "Er'body dead - space to start over", @large_font, 0xfffd7e005) if @grid.alive[i][j]
    end

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
    when Gosu::KbSpace
      if @state == :building
        @state = :running
      else
        @state = :building
      end
    end
  end

  def needs_cursor?
    true
  end

  def update
    @grid.make_babies if @state == :running
  end

  def draw_text(row, col, text, font, color)
    coords = coords_to_px(row, col)
    font.draw(text, coords[0], coords[1], 3, 1, 1, color)
  end

  def draw_cell(row, col)
    coords = coords_to_px(row, col)
    @cell.draw(coords[0], coords[1], 1, 0.45, 0.45)

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

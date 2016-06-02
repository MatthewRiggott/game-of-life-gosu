require 'pry'

class Cells
  attr_reader :col_size, :row_size, :alive, :living
  def initialize(col_size, row_size)
    @col_size = col_size
    @row_size = row_size
    @alive = Array.new(@col_size + 2) { |i| Array.new(@row_size + 2) { |i| false } }
    @living = []
  end

  def toggle(col, row)
    @alive[col][row] = !@alive[col][row]
    @alive[col][row]
    @living << [col, row] if @alive[col][row]
    @living.delete([col,row]) if !@alive[col][row]
  end

  def dead?
    return @living.empty
  end

  def clear_board
    @alive.each {|row| row.each {|cell| cell == false}}
    @living = []
  end

  def propagate
    @future = Array.new(@col_size + 2) { |i| Array.new(@row_size + 2) { |i| 0 } }
    if !@living.empty?
      @living.each do |xy|
        x, y = xy[0], xy[1]
        @future[x-1][y-1]+=1; @future[x][y-1]+=1; @future[x+1][y-1]+=1; @future[x-1][y]+=1
        @future[x-1][y+1]+=1; @future[x][y+1]+=1; @future[x+1][y+1]+=1; @future[x+1][y]+=1
      end
      (1..col_size).each_with_index do |col|
        (1..row_size).each_with_index do |row|
          case @future[col][row]

          when 0..1
            if alive[col][row]
              @living.delete([col, row])
              @alive[col][row] = false
            end

          when 2
          when 3
            if !alive[col][row]
              @living << [col,row]
              @alive[col][row] = true
            end
          when 4..10
            if @alive[col][row]
              @living.delete([col, row])
              @alive[col][row] = false
            end
          end
        end
      end
    end
  end
end

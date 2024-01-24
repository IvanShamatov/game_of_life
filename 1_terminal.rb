require 'tty-cursor'

class GameTerm

  WIDTH = 180 # cells
  HEIGHT = 45 # cells

  attr_accessor :field

  def initialize
    @field = Array.new(HEIGHT) { Array.new(WIDTH) { [0,0,0,0,1].sample } }
    @cursor = TTY::Cursor
  end

  def update
    updated_field = Array.new(HEIGHT) { Array.new(WIDTH) { 0 } }

    field.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        n = count_neighbours(x,y)

        if cell == 0
          updated_field[y][x] = 1 if n == 3
        else
          updated_field[y][x] = 1 if n == 2 || n == 3
        end
      end
    end

    self.field = updated_field
  end

  def draw
    field.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        print(cell == 1 ? 'O' : ' ')
      end
      print("\n")
    end
    print @cursor.move_to(1, 0)
  end

  def count_neighbours(x, y)
    field[(y > 0 ? y - 1 : 0)..(y < HEIGHT ? y + 1 : HEIGHT)]
      .map { _1[(x > 0 ? x - 1 : 0)..(x < WIDTH ? x + 1 : WIDTH)] }
      .flatten
      .sum - field[y][x]
  end

  def show
    loop do
      update
      draw
      sleep 0.015
    end
  end
end

GameTerm.new.show

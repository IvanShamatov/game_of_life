require 'gosu'
class GameGosu < Gosu::Window

  WIDTH = 100 # cells
  HEIGHT = 100 # cells
  CELL = 5   # px
  attr_accessor :field

  def initialize
    super(WIDTH*CELL, HEIGHT*CELL)
    self.caption = "Game of life"

    @field = Array.new(HEIGHT) { Array.new(WIDTH) { [0,0,1].sample } }
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
        draw_cell(x, y) if cell != 0
      end
    end
    puts Time.now
  end

  def count_neighbours(x, y)
    field[(y > 0 ? y - 1 : 0)..(y < HEIGHT ? y + 1 : HEIGHT)]
      .map { _1[(x > 0 ? x - 1 : 0)..(x < WIDTH ? x + 1 : WIDTH)] }
      .flatten
      .sum - field[y][x]
  end

  def draw_cell(x, y)
    Gosu.draw_rect(x * CELL, y * CELL, CELL, CELL, Gosu::Color::GREEN)
  end
end

# GameGosu.new.show

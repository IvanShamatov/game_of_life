require 'raylib'

s = Gem::Specification.find_by_name('raylib-bindings')
shared_lib_path = s.full_gem_path + '/lib/'
arch = RUBY_PLATFORM.split('-')[0]

Raylib.load_lib(shared_lib_path + "libraylib.#{arch}.so", raygui_libpath: shared_lib_path + "raygui.#{arch}.so", physac_libpath: shared_lib_path + "physac.#{arch}.so")

class GameRay
  include Raylib

  WIDTH = 100 # cells
  HEIGHT = 100 # cells
  CELL = 5   # px
  attr_accessor :field

  def initialize
    @width = WIDTH
    @height = HEIGHT
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
    BeginDrawing()
      ClearBackground(BLACK)
      field.each_with_index do |row, y|
        row.each_with_index do |cell, x|
          draw_cell(x, y) if cell != 0
        end
      end
    EndDrawing()
    puts Time.now
  end

  def count_neighbours(x, y)
    field[(y > 0 ? y - 1 : 0)..(y < HEIGHT ? y + 1 : HEIGHT)]
      .map { _1[(x > 0 ? x - 1 : 0)..(x < WIDTH ? x + 1 : WIDTH)] }
      .flatten
      .sum - field[y][x]
  end

  def draw_cell(x, y)
    DrawRectangle(x * CELL, y * CELL, CELL, CELL, GREEN)
  end

  def show
    InitWindow(CELL * WIDTH, CELL * HEIGHT, 'Game of life')
    SetTargetFPS(60)

    until WindowShouldClose()
      update
      draw
    end

    CloseWindow()
  end
end

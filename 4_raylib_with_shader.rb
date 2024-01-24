require 'raylib'

s = Gem::Specification.find_by_name('raylib-bindings')
shared_lib_path = s.full_gem_path + '/lib/'
arch = RUBY_PLATFORM.split('-')[0]

Raylib.load_lib(shared_lib_path + "libraylib.#{arch}.so", raygui_libpath: shared_lib_path + "raygui.#{arch}.so", physac_libpath: shared_lib_path + "physac.#{arch}.so")

class GameRayShader
  include Raylib

  WIDTH = 1000 # cells
  HEIGHT = 1000 # cells
  CELL = 1   # px
  attr_accessor :field

  def setup_states(texture_width, texture_height)
    image = GenImageWhiteNoise(texture_width, texture_height, 0.05)
    states = [
      LoadRenderTexture(texture_width, texture_height),
      LoadRenderTexture(texture_width, texture_height)
    ]
    UpdateTexture(states[0].texture, image.data)
    states
  end

  def setup_shader(texture_width, texture_height)
    shader = LoadShader(nil, "./gol.fs")
    resolution = Vector2.create(texture_width, texture_height)
    resolution_loc = GetShaderLocation(shader, "resolution")
    SetShaderValue(shader, resolution_loc, resolution, SHADER_UNIFORM_VEC2)
    shader
  end

  def show
    texture_width = WIDTH * CELL
    texture_height = HEIGHT * CELL
    InitWindow(texture_width, texture_height, 'Game of life')
    SetTargetFPS(60)

    states = setup_states(texture_width, texture_height)
    shader = setup_shader(texture_width, texture_height)

    i = 0
    until WindowShouldClose()
      BeginTextureMode(states[1-i])
        ClearBackground(BLACK)
        BeginShaderMode(shader)
          DrawTexture(states[i].texture, 0, 0, GREEN)
        EndShaderMode()
      EndTextureMode()

      i = 1 - i

      BeginDrawing()
        ClearBackground(BLACK)
        DrawTexture(states[i].texture, 0, 0, GREEN)
      EndDrawing()
    end

    CloseWindow()
  end
end

GameRayShader.new.show

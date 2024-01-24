require 'raylib'

s = Gem::Specification.find_by_name('raylib-bindings')
shared_lib_path = s.full_gem_path + '/lib/'
arch = RUBY_PLATFORM.split('-')[0]

Raylib.load_lib(shared_lib_path + "libraylib.#{arch}.so", raygui_libpath: shared_lib_path + "raygui.#{arch}.so", physac_libpath: shared_lib_path + "physac.#{arch}.so")

class SmoothGame
  include Raylib

  FACTOR = 100
  WIDTH = 16 * FACTOR
  HEIGHT = 9 * FACTOR
  SCALAR = 1
  TEXTURE_WIDTH = WIDTH*SCALAR
  TEXTURE_HEIGHT = HEIGHT*SCALAR

  attr_accessor :field

  def setup_states(texture_width, texture_height)
    image = GenImagePerlinNoise(texture_width, texture_height, 0, 0, 3.0);

    states = [
      LoadRenderTexture(texture_width, texture_height),
      LoadRenderTexture(texture_width, texture_height)
    ]
    UpdateTexture(states[0].texture, image.data)
    states
  end

  def setup_shader(texture_width, texture_height)
    shader = LoadShader(nil, "./smoothlife.fs")
    resolution = Vector2.create(texture_width, texture_height)
    resolution_loc = GetShaderLocation(shader, "resolution")
    SetShaderValue(shader, resolution_loc, resolution, SHADER_UNIFORM_VEC2)
    shader
  end

  def show
    InitWindow(TEXTURE_WIDTH, TEXTURE_HEIGHT, 'Game of life')
    SetTargetFPS(20)

    states = setup_states(TEXTURE_WIDTH, TEXTURE_HEIGHT)
    shader = setup_shader(TEXTURE_WIDTH, TEXTURE_HEIGHT)

    i = 0
    until WindowShouldClose()
      BeginTextureMode(states[1-i])
        ClearBackground(BLACK)
        BeginShaderMode(shader)
          DrawTexture(states[i].texture, 0, 0, YELLOW)
        EndShaderMode()
      EndTextureMode()

      i = 1 - i

      BeginDrawing()
        ClearBackground(BLACK)
        # DrawTextureEx(states[i].texture, Vector2.create(0,0), 0, 1/SCALAR, WHITE);
        DrawTexture(states[i].texture, 0, 0, YELLOW)
      EndDrawing()
    end

    CloseWindow()
  end
end

SmoothGame.new.show

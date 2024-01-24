#version 330

// Input vertex attributes (from vertex shader)
in vec2 fragTexCoord;
in vec4 fragColor;

// Input uniform values
uniform sampler2D previousState;
uniform vec4 colDiffuse;

// Output fragment color
out vec4 finalColor;

uniform vec2 resolution;

int wasAlive(vec2 coord) {
  if (coord.x < 0.0 || resolution.x < coord.x || coord.y < 0.0 || resolution.y < coord.y) return 0;
  vec4 px = texture(previousState, coord/resolution);
  return px.g < 0.1 ? 0 : 1;
}

void main(){
  vec2 coord = vec2(gl_FragCoord);
  int aliveNeighbors =
    wasAlive(coord+vec2(-1.,-1.)) +
    wasAlive(coord+vec2(-1.,0.)) +
    wasAlive(coord+vec2(-1.,1.)) +
    wasAlive(coord+vec2(0.,-1.)) +
    wasAlive(coord+vec2(0.,1.)) +
    wasAlive(coord+vec2(1.,-1.)) +
    wasAlive(coord+vec2(1.,0.)) +
    wasAlive(coord+vec2(1.,1.));

  bool nowAlive = false;
  if(wasAlive(coord) == 1) {
    if (2 <= aliveNeighbors && aliveNeighbors <= 3) {
      nowAlive = true;
    }
  } else {
    nowAlive = aliveNeighbors == 3;
  }

  finalColor = nowAlive ? vec4(1.,1.,1.,1.) : vec4(0.,0.,0.,1.);
}

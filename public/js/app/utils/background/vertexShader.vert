uniform sampler2D heightmap;
varying vec2 planePosition;
void main() {
	vec4 newPosition = modelMatrix * vec4(position, 1.0);
	planePosition = vec2(newPosition.x / 1000.0 + 0.5, newPosition.z / 300.0 + 0.5);
	newPosition.y += texture2D(heightmap, planePosition).x * 120.0 - 60.0;
	gl_Position = projectionMatrix * viewMatrix * newPosition;
}
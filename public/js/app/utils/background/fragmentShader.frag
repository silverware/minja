uniform sampler2D heightmap;
varying vec2 planePosition;
void main() {
	float color = texture2D(heightmap, planePosition).x;
	float deltaY = planePosition.y + 0.01;
	float deltaZ, color2;
	if (deltaY > 1.0) {
		color2 = texture2D(heightmap, vec2(planePosition.x, planePosition.y - 0.01)).x;
		deltaZ =  (color - color2) * 1.29;
	} else {
		color2 = texture2D(heightmap, vec2(planePosition.x, deltaY)).x;
		deltaZ = (color2 - color) * 1.29;
	}
	gl_FragColor = vec4(deltaZ * 9.0 + 0.14);
}
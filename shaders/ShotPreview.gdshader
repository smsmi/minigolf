shader_type canvas_item;

uniform float speed = 1.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 new_UV = mod(UV - vec2(TIME * speed,0), 1);
	COLOR = texture(TEXTURE, new_UV);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

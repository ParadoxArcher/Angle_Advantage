shader_type canvas_item;

uniform vec4 color : source_color;
uniform float flashState : hint_range(0, 1, .05) = .5;

void fragment() {
	vec4 pixelColor = texture(TEXTURE, UV);
	COLOR =  mix(pixelColor, color, flashState);
	COLOR.a *= pixelColor.a;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

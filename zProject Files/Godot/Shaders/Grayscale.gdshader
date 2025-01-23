shader_type canvas_item;

void fragment() {
	vec4 InputColor = texture(TEXTURE, UV);
	float GrayScale = (InputColor.r + InputColor.g + InputColor.b) / 3.0;
	COLOR = vec4(GrayScale, GrayScale, GrayScale, 1.0);
}

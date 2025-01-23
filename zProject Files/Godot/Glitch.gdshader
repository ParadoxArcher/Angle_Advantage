shader_type canvas_item;

uniform float Speed : hint_range(0.0, 5.0, 0.1) = 2.;
uniform float Frequency : hint_range(0.0, 5.0, 0.1) = .5;
uniform float Amp : hint_range(0.0, 5.0, 0.05) = .05;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

float rand() {
	return sin((screen_uv.y + TIME * Speed);
}

void fragment() {
	vec2 screen_uv = SCREEN_UV;
	float YSine = sin((screen_uv.y  * Speed) * Frequency) * Amp;
	screen_uv.x += YSine;
	vec4 PixelColor = texture(SCREEN_TEXTURE, screen_uv);
	
	COLOR = PixelColor;
}


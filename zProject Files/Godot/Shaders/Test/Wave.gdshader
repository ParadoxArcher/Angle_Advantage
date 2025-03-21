shader_type canvas_item;

uniform float fillHeight = .2;
uniform float frequency = 1.5;
uniform float amp = .2;
uniform float speed = 1.5;

uniform vec4 backgroundColor: source_color = vec4(1., 1., 1., 1.);
uniform vec4 waveColor: source_color;

vec4 wave(vec2 uv) {
	float sinus = sin((uv.x * PI + TIME * speed) * frequency) * amp;
	return waveColor * step(.5 - sinus, fillHeight + uv.y);
}

void fragment() {
	vec4 wave = wave(UV);
	COLOR.rgb = mix(backgroundColor, wave, wave.a).rgb; // use COLOR instead of backgroundColor to use image background
}

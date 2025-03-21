shader_type canvas_item;

uniform sampler2D noise_texture : repeat_enable;
uniform float scrollSpeed = .1;
uniform float noiseFilter : hint_range(0., 255., 5.);


void fragment() {
	vec4 PixelColor = texture(TEXTURE, UV);
	
	vec2 uvUpdate = vec2(UV.x + TIME * scrollSpeed, UV.y);
	float noiseStrength = (texture(noise_texture, uvUpdate).r + texture(noise_texture, uvUpdate).g + texture(noise_texture, uvUpdate).b ) / 3.;
	
	if (noiseStrength <= noiseFilter / 255.) {
		noiseStrength = 0.;
	}
	
	PixelColor.a = mix(texture(TEXTURE, UV).a, -1, noiseStrength);
	COLOR = PixelColor;
}

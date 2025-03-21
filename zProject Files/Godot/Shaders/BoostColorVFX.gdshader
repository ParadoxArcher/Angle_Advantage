shader_type canvas_item;

uniform sampler2D noise_texture : repeat_enable;
uniform vec2 ScrollVelocity;
uniform bool NoiseAlphaFilterActive = false;
uniform float AlphaFilterStrength : hint_range(0.0, 1.0, .05) = 1.;
uniform bool NoiseDistortionActive = false;
uniform vec3 DistortionColorStrengthX;
uniform vec3 DistortionColorStrengthY;
//endregion

//region Color Organizer --- Set the ColorFilter to delete all colors below that and scale the values proportional to whats remaining
uniform float RedFilter : hint_range(.0, 1, .01) = .1;
uniform vec4 RedColor: source_color;
uniform float GreenFilterLeft : hint_range(.0, 1, .01) = .1;
uniform float GreenFilterRight : hint_range(.0, 1, .01) = .1;
uniform vec4 GreenColor: source_color;
uniform float BlueFilter : hint_range(.0, 1, .01) = .1;
uniform vec4 BlueColor: source_color;
//endregion

void fragment() {
	vec4 NoiseFilter = vec4(1., 1., 1., 1.);
	vec3 DistortedUVx = vec3(UV.x, UV.x, UV.x);
	vec3 DistortedUVy = vec3(UV.y, UV.y, UV.y);
	if (NoiseAlphaFilterActive == true || NoiseDistortionActive == true) {
		vec2 NoiseUV = vec2(UV + TIME * ScrollVelocity);
		float NoiseBrightness = (texture(noise_texture, NoiseUV).r + texture(noise_texture, NoiseUV).g + texture(noise_texture, NoiseUV).b ) / 3.;
		if (NoiseAlphaFilterActive == true) {
			NoiseFilter = vec4(1., 1., 1., mix(1., NoiseBrightness / 2., AlphaFilterStrength)); // [/ 2.] serves to improve contrast for AlphaFilterStrength
		}
		if (NoiseDistortionActive == true){
			DistortedUVx += (NoiseBrightness - .5) * DistortionColorStrengthX;
			DistortedUVy += (NoiseBrightness - .5) * DistortionColorStrengthY;
	}	}
	
	vec4 PixelSample = texture(TEXTURE, UV);
		/* Distortion application */
	PixelSample.r = texture(TEXTURE, vec2(DistortedUVx.r, DistortedUVy.r)).r;
	PixelSample.g = texture(TEXTURE, vec2(DistortedUVx.g, DistortedUVy.g)).g;
	PixelSample.b = texture(TEXTURE, vec2(DistortedUVx.b, DistortedUVy.b)).b;
	
	
	float GreenFilter = (1. - GreenFilterLeft * (abs(UV.x - 1.) / 2. ) ) + (1. - GreenFilterRight * ((UV.x + 1. ) / 2. ) );
	
	// Cumulatively adds colors together into the opacity    /* Remove [ * NoiseFilter] to remove Noise Alpha Filtering from any of the following colors */	
	vec4 PixelColor = RedColor * smoothstep(RedFilter, 1., PixelSample.r) * NoiseFilter;
	PixelColor += (vec4(1., 1., 1., 1.) - PixelColor ) * GreenColor * smoothstep(GreenFilter, 1., PixelSample.g) * NoiseFilter;
	PixelColor += (vec4(1., 1., 1., 1.) - PixelColor ) * BlueColor * smoothstep(BlueFilter, 1., PixelSample.b) * NoiseFilter;
	
	COLOR = PixelColor;
}

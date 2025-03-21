/* Shader overview */
// This shader takes the colors in the image and set's it's rgb to one preselected color, while the alpha is set by the sprite's RGB
// The color "Scales" are used to filter out a portion of one color's and is meant to be accessed mid-game with script

/* Image Notes*/
// - [Mandatory] Use a Black Background to prevent alpha stretching 
// - In your art software of choice...
// - - Separate each color used by layer & use "additive" blend to mix them
// - - Using "Erase" clipping layers will help for creating transparency
// - - Adjust opacity of "Erase" layers to adjust individual element's transparency
// - Transparency can be adjusted by setting the "source_color" to have lowered alpha if the image as a whole isn't transparent enough

shader_type canvas_item;

//Call this shader's Sprite2D and use [.material.set_shader_parameter("ParameterName", value)] to adjust any uniform value with code

//region Noise Variables --- Adjusts noise stuff
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
uniform float GreenFilter : hint_range(.0, 1, .01) = .1;
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
	
	// Cumulatively adds colors together into the opacity    /* Remove [ * NoiseFilter] to remove Noise Alpha Filtering from any of the following colors */
	vec4 PixelColor = RedColor * smoothstep(RedFilter, 1., PixelSample.r) * NoiseFilter;
	PixelColor += (vec4(1., 1., 1., 1.) - PixelColor ) * GreenColor * smoothstep(GreenFilter, 1., PixelSample.g) * NoiseFilter;
	PixelColor += (vec4(1., 1., 1., 1.) - PixelColor ) * BlueColor * smoothstep(BlueFilter, 1., PixelSample.b) * NoiseFilter;
	
	COLOR = PixelColor;
}

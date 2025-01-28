### Final Work
###### Description of contents

#### Steps
1) Setup #ColorFilter 
	1) Set `shader_type` to `canvas_item`
		1) `shader_type canvas_item;
	2) Export #RedFilter, #GreenFilter, & #BlueFilter
		1) `uniform float RedFilter : hint_range(.0, 1, .01) = .1;
		2) `uniform float GreenFilter : hint_range(.0, 1, .01) = .1;
		3) `uniform float BlueFilter : hint_range(.0, 1, .01) = .1;
	3) As `global variables` export #RedColor, #GreenColor, & #BlueColor as `source_color`
		1) `uniform vec4 RedColor: source_color;
		2) `uniform vec4 GreenColor: source_color;
		3) `uniform vec4 BlueColor: source_color; 
	4) Inside `Fragment () {
		1) Sample texture of image
			1) `vec4 PixelSample = texture(TEXTURE, UV);
		2) Call and Define #PixelColor as the #ColorFilter's corresponding #ColorColor * a `smoothstep` of #PixelSample between the #ColorFilter and 100%, making sure adjust #GreenFilter and #BlueFilter to be cumulative additions
			1) `vec4 PixelColor = RedColor * smoothstep(RedFilter, 1., PixelSample.r);
			2) `PixelColor += (vec4(1., 1., 1., 1.) - PixelColor ) * GreenColor * smoothstep(GreenFilter, 1., PixelSample.g);
			3) `PixelColor += (vec4(1., 1., 1., 1.) - PixelColor ) * BlueColor * smoothstep(BlueFilter, 1., PixelSample.b);
2) #NoiseFilter
	1) Export a `Sampler2D: noise_texture` request with `repeat` enabled
		1) `uniform sampler2D noise_texture : repeat_enable;
	2) Export #ScrollVelocity, #NoiseAlphaFilterActive, & #AlphaFilterStrength
		1) `uniform vec2 ScrollVelocity;
		2) `uniform bool NoiseAlphaFilterActive = false;
		3) `uniform float AlphaFilterStrength : hint_range(0.0, 1.0, .05) = 1.;
	3) Call #NoiseFilter, then if #NoiseAlphaFilterActive is true, we scroll #NoiseFilter by the #ScrollVelocity before determining the #NoiseBrightness as a grayscale of itself, which we use to amplify the #NoiseFilter 
		1) `vec4 NoiseFilter = vec4(1., 1., 1., 1.);
		2) `if (NoiseAlphaFilterActive == true) {
			1) `vec2 NoiseUV = vec2(UV + TIME * ScrollVelocity);
			2) `float NoiseBrightness = (texture(noise_texture, NoiseUV).r + texture(noise_texture, NoiseUV).g + texture(noise_texture, NoiseUV).b ) / 3.;
			3) `NoiseFilter = vec4(1., 1., 1., mix(1., NoiseBrightness / 2., AlphaFilterStrength));
	4) Multiply every step of #ColorFilter by #NoiseFilter
		1) `vec4 PixelColor = RedColor * smoothstep(RedFilter, 1., PixelSample.r) * NoiseFilter;
		2) `PixelColor += (vec4(1., 1., 1., 1.) - PixelColor ) * GreenColor * smoothstep(GreenFilter, 1., PixelSample.g) * NoiseFilter;
		3) `PixelColor += (vec4(1., 1., 1., 1.) - PixelColor ) * BlueColor * smoothstep(BlueFilter, 1., PixelSample.b) * NoiseFilter;`
3) #NoiseDistortion
	1) Export #NoiseDistortionActive as false, #DistortionColorStrengthX , & #DistortionColorStrengthY
		1) `uniform bool NoiseDistortionActive = false;
		2) `uniform vec3 DistortionColorStrengthX;
		3) `uniform vec3 DistortionColorStrengthY;
	2) Before `if (NoiseAlphaFilterActive == true) {` call #DistortedUVx and #DistortedUVy
		1) `vec3 DistortedUVx = vec3(UV.x, UV.x, UV.x);
		2) `vec3 DistortedUVy = vec3(UV.y, UV.y, UV.y);
	3) Set `if (NoiseAlphaFilterActive == true) {` to accept if #NoiseDistortionActive is true
		1) `if (NoiseAlphaFilterActive == true || NoiseDistortionActive == true) {
	4) Set `NoiseFilter` to only be defined while #NoiseAlphaFilterActive is true
		1) `if (NoiseAlphaFilterActive == true) {
			1) `NoiseFilter = vec4(1., 1., 1., mix(1., NoiseBrightness / 2., AlphaFilterStrength)); // [/ 2.] serves to improve contrast for AlphaFilterStrength
	5) `if` #NoiseDistortionActive is `true`, define #DistortedUVx and #DistortedUVy based on #NoiseBrightness  * #DistortionColorStrengthX and #DistortionColorStrengthY respectively
		1) `if (NoiseDistortionActive == true){
			1) `DistortedUVx += (NoiseBrightness - .5) * DistortionColorStrengthX;
			2) `DistortedUVy += (NoiseBrightness - .5) * DistortionColorStrengthY;`
	6) Adjust #PixelSample result by each color's distortedUV

### Adjustment Log
- 
	- 
	 
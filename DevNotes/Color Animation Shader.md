### Final Work
###### Description of contents

#### Steps
1) As `global variables` export #RedFilter, #GreenFilter, & #BlueFilter
	1) `uniform float RedFilter : hint_range(.0, 1, .01) = .1;
	2) `uniform float GreenFilter : hint_range(.0, 1, .01) = .1;
	3) `uniform float BlueFilter : hint_range(.0, 1, .01) = .1;
2) As `global variables` export #RedColor, #GreenColor, & #BlueColor as `source_color`
	1) `uniform vec4 RedColor: source_color;
	2) `uniform vec4 GreenColor: source_color;
	3) `uniform vec4 BlueColor: source_color; 
3) Sample texture of image
	1) `vec4 PixelSample = texture(TEXTURE, UV);
4) Call and Define #PixelColor as the #ColorFilter's corresponding #ColorColor * a `smoothstep` of #PixelSample between the #ColorFilter and 100%. making sure multiply #GreenFilter and #BlueFilter by 
	1) `vec4 PixelColor = RedColor * smoothstep(RedFilter, 1., PixelSample.r) * NoiseFilter;
	PixelColor += (vec4(1., 1., 1., 1.) - PixelColor ) * GreenColor * smoothstep(GreenFilter, 1., PixelSample.g) * NoiseFilter;
	PixelColor += (vec4(1., 1., 1., 1.) - PixelColor ) * BlueColor * smoothstep(BlueFilter, 1., PixelSample.b)

### Adjustment Log
- 
	- 
	 
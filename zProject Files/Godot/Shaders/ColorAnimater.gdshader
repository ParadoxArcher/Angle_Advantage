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

//region --- call this shader's Sprite2D and use [.material.set_shader_parameter("ParameterName", value)] to adjust any uniform value with code

uniform vec4 color : source_color;
// Set the ColorScale to delete all colors below that and scale the values proportional to whats remaining
uniform float RedScale : hint_range(.0, 1, .01) = .1;
uniform vec4 RedColor: source_color;
uniform float GreenScale : hint_range(.0, 1, .01) = .1;
uniform vec4 GreenColor: source_color;
uniform float BlueScale : hint_range(.0, 1, .01) = .1;
uniform vec4 BlueColor: source_color;
//endregion

void fragment() {
	vec4 PixelSample = texture(TEXTURE, UV);	
	
	// Cumulatively adds colors together into the opacity
	vec4 PixelColor = RedColor * smoothstep(RedScale, 1., PixelSample.r);
	PixelColor += (vec4(1., 1., 1., 1.) - PixelColor ) * GreenColor * smoothstep(GreenScale, 1., PixelSample.g);
	PixelColor += (vec4(1., 1., 1., 1.) - PixelColor ) * BlueColor * smoothstep(BlueScale, 1., PixelSample.b);
	
	COLOR = PixelColor;
}

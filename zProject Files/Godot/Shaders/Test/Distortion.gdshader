shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

uniform float DistortionX : hint_range(-1.0, 1.0, 0.05);
uniform float DistortionY : hint_range(-1.0, 1.0, 0.05);

void fragment() {
	vec2 distortedUV = UV;
	distortedUV.x += DistortionX;
	distortedUV.y += DistortionY;
	
	vec4 pixelColor = texture(TEXTURE, distortedUV);
	
	COLOR = pixelColor; 
}
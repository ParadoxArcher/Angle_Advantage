shader_type canvas_item;

uniform float RedFilter : hint_range(0.0, 255, 5.0) = 0.0;
uniform float GreenFilter : hint_range(0.0, 255, 5.0) = 0.0;
uniform float BlueFilter : hint_range(0.0, 255, 5.0) = 0.0;

void fragment() {
	
	vec4 pixelColor = texture(TEXTURE, UV);
	
	if (pixelColor.r <= RedFilter/255.0) {
		pixelColor.r = 0.0;
	}
	if (pixelColor.g <= GreenFilter/255.0) {
		pixelColor.g = 0.0;
	}
	if (pixelColor.b <= BlueFilter/255.0) {
		pixelColor.b = 0.0;
	}
	
	COLOR = pixelColor;
	
}

shader_type canvas_item;

const vec2 SCREEN_SIZE = vec2(840, 480);

uniform bool use_effect = true;
uniform vec2 resolution = vec2(84, 48);
uniform vec4 black : hint_color = vec4(vec3(0.0), 1.0);
uniform vec4 white : hint_color = vec4(vec3(1.0), 1.0);
uniform float line_strength : hint_range(0.0, 1.0) = 0.5;
uniform bool flip_colors = false;

vec3 add_corner_dots(vec3 color, vec2 uv, ivec2 batch_size, vec2 pixel_size) {
	ivec2 new_uv = ivec2(uv * SCREEN_SIZE);
	if (
		(new_uv.x) % (batch_size.x) == 0 ||
		(new_uv.y) % (batch_size.y) == 0
	) {
		color.rgb = mix(color.rgb, white.rgb, line_strength );
	}
	return color;
}

vec3 color_avg_at(sampler2D tex, vec2 pos, ivec2 batch_size, vec2 pixel_size) {
	vec2 base_uv = pos / resolution;
	int width = batch_size.x,
		height = batch_size.y,
		size = width * height;
	
	vec3 color = vec3(0.0);
	for (int y = 0; y < height; y++) {
		for (int x = 0; x < width; x++) {
			vec2 offset = vec2(float(x), float(y));
			color += texture(tex, base_uv + (offset+vec2(0.5)) * pixel_size).rgb;
		}
	}
	
	color /= float(size);
	return color;
}

void fragment() {
	vec2 pos = floor(UV * resolution);
	vec2 uv = pos / resolution;
	ivec2 batch_size = ivec2(SCREEN_SIZE) / ivec2(resolution);
	
	vec3 color = color_avg_at(TEXTURE, pos, batch_size, TEXTURE_PIXEL_SIZE);
	float grayscale = (color.r + color.g + color.b) / 3.0;
//	color = vec3(grayscale);
	if (grayscale < 0.5)
		color = (flip_colors ? white : black).rgb;
	else
		color = (flip_colors ? black : white).rgb;

	color = add_corner_dots(color, UV, batch_size, TEXTURE_PIXEL_SIZE);
	
	COLOR.rgb = use_effect ? color : texture(TEXTURE, UV).rgb;
}

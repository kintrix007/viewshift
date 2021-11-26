shader_type canvas_item;

uniform float effect_range : hint_range(0.0, 2.0) = 0.0;

void fragment() {
	float effect_mult = 1.7;
	float effect = effect_range * effect_mult;
	vec3 color = texture(TEXTURE, UV).rgb;
	float mid_dist = abs(UV.y - 0.5);
	
	if (!(
		1.0 - UV.x + mid_dist > effect ||
		-UV.x + (effect_mult-0.5) + mid_dist < effect - effect_mult
	)) {
		color = vec3(0.0);
	}
	
	if (!(
		1.1 - UV.x + mid_dist > effect ||
		-UV.x + (effect_mult-0.6) + mid_dist < effect - effect_mult
	)) {
		color = vec3(1.0);
	}
	
	COLOR.rgb = color;
}
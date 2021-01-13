shader_type spatial;
render_mode unshaded, blend_mix, depth_draw_never, cull_back;
uniform vec4 albedo : hint_color;
uniform sampler2D texture_albedo : hint_albedo;

uniform float roughness : hint_range(0,1);
uniform sampler2D texture_metallic : hint_white;
uniform vec4 metallic_texture_channel = vec4(1.0, 0.0, 0.0, 0.0);
uniform sampler2D texture_roughness : hint_white;
uniform vec4 roughness_texture_channel = vec4(1.0, 0.0, 0.0, 0.0);
uniform sampler2D texture_emission : hint_black_albedo;
uniform vec4 emission : hint_color;
uniform float emission_energy;
uniform sampler2D texture_refraction;
uniform float refraction : hint_range(-16,16);
uniform vec4 refraction_texture_channel = vec4(1.0, 0.0, 0.0, 0.0);
uniform vec2 uv_scale = vec2(1.0, 1.0);
uniform vec2 uv_offset;
uniform float proximity_fade_distance;
uniform float distance_fade_min;
uniform float distance_fade_max;
uniform vec4 deep_color : hint_color;
uniform vec4 shallow_color : hint_color = vec4(1);

uniform float refraction_speed = 0.25;
uniform float refraction_strength = 1.0;

uniform float foam_amount = 1.0;
uniform float foam_cutoff = 1.0;
uniform vec4 foam_color : hint_color = vec4(1);

uniform float displacement_strength = 0.25;

uniform float depth_distance = 1.0;

uniform vec2 movement_direction = vec2(1,0);

uniform sampler2D refraction_noise : hint_normal;
uniform sampler2D foam_noise : hint_black_albedo;
uniform sampler2D displacement_noise : hint_black;

uniform sampler2D texture_normal : hint_normal;
uniform float normal_scale : hint_range(-16,16);
uniform float flow_normal_influence : hint_range(0, 1);

// Flow / Water uniforms
uniform sampler2D texture_flow_map : hint_normal;
uniform vec4 flow_map_x_channel = vec4(1.0, 0.0, 0.0, 0.0);
uniform vec4 flow_map_y_channel = vec4(0.0, 1.0, 0.0, 0.0);
uniform vec2 channel_flow_direction = vec2(1.0, -1.0);
uniform float blend_cycle = 1.0;
uniform float cycle_speed = 1.0;
uniform float flow_speed =  0.5;

uniform sampler2D texture_flow_noise;
uniform vec4 noise_texture_channel = vec4(1.0, 0.0, 0.0, 0.0);
uniform vec2 flow_noise_size = vec2(1.0, 1.0);
uniform float flow_noise_influence = 0.5;


varying vec2 base_uv;

void vertex() {
	base_uv = UV * uv_scale.xy + uv_offset.xy;

  float displacement = textureLod(displacement_noise, UV + (TIME * movement_direction) * refraction_speed, 0.1).r * 5.0 - 1.0;
	VERTEX.y += displacement * displacement_strength;
}

void fragment() {
	// UV flow  calculation
	/****************************************************************************************************/
	float half_cycle = blend_cycle * 0.5;
    
	// Use noise texture for offset to reduce pulsing effect
	float offset = dot(texture(texture_flow_noise, UV * flow_noise_size), noise_texture_channel) * flow_noise_influence;

	float phase1 = mod(offset + TIME * cycle_speed, blend_cycle);
	float phase2 = mod(offset + TIME * cycle_speed + half_cycle, blend_cycle);

	vec4 flow_tex = texture(texture_flow_map, UV);
	vec2 flow;
	flow.x = dot(flow_tex, flow_map_x_channel) * 2.0 - 1.0;
	flow.y = dot(flow_tex, flow_map_y_channel) * 2.0 - 1.0;
	flow *= normalize(channel_flow_direction);

	// Make flow incluence on the normalmap strenght adjustable (optional)
	float normal_influence = mix(1.0, dot(abs(flow), vec2(1.0, 1.0)) * 0.5, flow_normal_influence);

	// Blend factor to mix the two layers
	float blend_factor = abs(half_cycle - phase1)/half_cycle;

	// Offset by halfCycle to improve the animation for color (for normalmap not absolutely necessary)
	phase1 -= half_cycle;
	phase2 -= half_cycle;

	// Multiply with scale to make flow speed independent from the uv scaling
	flow *= flow_speed * uv_scale;

	vec2 layer1 = flow * phase1 + base_uv;
	vec2 layer2 = flow * phase2 + base_uv;
	/****************************************************************************************************/

	// Albedo
	// Mix animated uv layers
	vec4 albedo_tex = mix(texture(texture_albedo, layer1), texture(texture_albedo, layer2), blend_factor);
	ALBEDO = albedo.rgb * albedo_tex.rgb;

	
	

	

	
	



	
    
    
}

shader_type canvas_item;

uniform float time_speed : hint_range(0.0, 5.0) = 1;

void fragment() {
    float t = clamp(TIME * time_speed, 0.0, 1.0);
    vec4 start_color = vec4(1.0, 1.0, 1.0, 1.0);           // white
    vec4 end_color   = vec4(0.53, 0.81, 0.98, 1.0);        // sky blue
    COLOR = mix(start_color, end_color, t);
}
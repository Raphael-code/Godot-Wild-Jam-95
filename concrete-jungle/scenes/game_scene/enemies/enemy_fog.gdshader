shader_type spatial;
render_mode unshaded, cull_disabled, blend_mix, depth_draw_never;

uniform vec4 fog_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform sampler2D noise_tex;
uniform float noise_scale = 3.0;
uniform vec2 noise_flow = vec2(0.2, 0.0);
uniform float fog_strength = 0.7;

uniform float edge_fade_size = 0.25;
uniform float noise_contrast = 0.5;
uniform float noise_low = 0.2;
uniform float noise_high = 0.8;

void fragment() {
    vec2 uv = UV * noise_scale;
    uv += noise_flow * TIME;

    float n1 = texture(noise_tex, uv).r;
    float n2 = texture(noise_tex, UV * (noise_scale * 1.7) - noise_flow * 0.7 * TIME).r;
    float n = n1 * 0.6 + n2 * 0.4;

    n = smoothstep(noise_low, noise_high, n);
    n = mix(0.5, n, noise_contrast);

    float fog = n * fog_strength;

    float edge_x = smoothstep(0.0, edge_fade_size, UV.x) * smoothstep(0.0, edge_fade_size, 1.0 - UV.x);
    float edge_y = smoothstep(0.0, edge_fade_size, UV.y) * smoothstep(0.0, edge_fade_size, 1.0 - UV.y);
    float edge = edge_x * edge_y;

    fog *= edge;

    ALBEDO = fog_color.rgb;
    ALPHA = fog * fog_color.a;
}
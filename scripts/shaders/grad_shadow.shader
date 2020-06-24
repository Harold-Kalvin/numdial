shader_type canvas_item;

render_mode blend_mix;

uniform sampler2D gradient: hint_black;
uniform vec4 shadow_modulate: hint_color;
uniform vec2 shadow_offset = vec2(8.0, 8.0);
uniform float shadow_radius = 4.0;

const float PI = 3.14159265358979323846;

vec2 rotateUV(vec2 uv, vec2 pivot, float rotation) {
    float sine = sin(rotation);
    float cosine = cos(rotation);

    uv -= pivot;
    uv.x = uv.x * cosine - uv.y * sine;
    uv.y = uv.x * sine + uv.y * cosine;
    uv += pivot;

    return uv;
}

void fragment() {
    // gradient
    vec4 sampled_color = texture(gradient, rotateUV(UV, vec2(0.5), PI/1.4));
    vec4 main_texture = vec4(sampled_color.rgb, texture(TEXTURE, UV).a * 1.0);
    
    // shadow
    vec2 ps = TEXTURE_PIXEL_SIZE;
    vec2 pos_with_offset = UV - shadow_offset * ps;
	vec4 shadow = vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset).a * 0.0);
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*-30.0, shadow_radius*-30.0)).a * shadow_modulate.a) * 0.001479;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*-29.0, shadow_radius*-29.0)).a * shadow_modulate.a) * 0.001815;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*-28.0, shadow_radius*-28.0)).a * shadow_modulate.a) * 0.002212;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*-27.0, shadow_radius*-27.0)).a * shadow_modulate.a) * 0.002678;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*-26.0, shadow_radius*-26.0)).a * shadow_modulate.a) * 0.003218;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*-25.0, shadow_radius*-25.0)).a * shadow_modulate.a) * 0.003841;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*-24.0, shadow_radius*-24.0)).a * shadow_modulate.a) * 0.004553;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*-23.0, shadow_radius*-23.0)).a * shadow_modulate.a) * 0.00536;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*-22.0, shadow_radius*-22.0)).a * shadow_modulate.a) * 0.006266;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*-21.0, shadow_radius*-21.0)).a * shadow_modulate.a) * 0.007274;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*-20.0, shadow_radius*-20.0)).a * shadow_modulate.a) * 0.008387;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*-19.0, shadow_radius*-19.0)).a * shadow_modulate.a) * 0.009602;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*-18.0, shadow_radius*-18.0)).a * shadow_modulate.a) * 0.010917;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*-17.0, shadow_radius*-17.0)).a * shadow_modulate.a) * 0.012327;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*-16.0, shadow_radius*-16.0)).a * shadow_modulate.a) * 0.013823;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*-15.0, shadow_radius*-15.0)).a * shadow_modulate.a) * 0.015393;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*-14.0, shadow_radius*-14.0)).a * shadow_modulate.a) * 0.017023;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*-13.0, shadow_radius*-13.0)).a * shadow_modulate.a) * 0.018695;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*-12.0, shadow_radius*-12.0)).a * shadow_modulate.a) * 0.020389;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*-11.0, shadow_radius*-11.0)).a * shadow_modulate.a) * 0.022083;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*-10.0, shadow_radius*-10.0)).a * shadow_modulate.a) * 0.023753;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*-9.0, shadow_radius*-9.0)).a * shadow_modulate.a) * 0.025372;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*-8.0, shadow_radius*-8.0)).a * shadow_modulate.a) * 0.026913;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*-7.0, shadow_radius*-7.0)).a * shadow_modulate.a) * 0.028351;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*-6.0, shadow_radius*-6.0)).a * shadow_modulate.a) * 0.02966;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*-5.0, shadow_radius*-5.0)).a * shadow_modulate.a) * 0.030814;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*-4.0, shadow_radius*-4.0)).a * shadow_modulate.a) * 0.031791;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*-3.0, shadow_radius*-3.0)).a * shadow_modulate.a) * 0.032573;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*-2.0, shadow_radius*-2.0)).a * shadow_modulate.a) * 0.033143;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*-1.0, shadow_radius*-1.0)).a * shadow_modulate.a) * 0.03349;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*0.0, shadow_radius*0.0)).a * shadow_modulate.a) * 0.033606;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*1.0, shadow_radius*1.0)).a * shadow_modulate.a) * 0.03349;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*2.0, shadow_radius*2.0)).a * shadow_modulate.a) * 0.033143;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*3.0, shadow_radius*3.0)).a * shadow_modulate.a) * 0.032573;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*4.0, shadow_radius*4.0)).a * shadow_modulate.a) * 0.031791;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*5.0, shadow_radius*5.0)).a * shadow_modulate.a) * 0.030814;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*6.0, shadow_radius*6.0)).a * shadow_modulate.a) * 0.02966;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*7.0, shadow_radius*7.0)).a * shadow_modulate.a) * 0.028351;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*8.0, shadow_radius*8.0)).a * shadow_modulate.a) * 0.026913;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*9.0, shadow_radius*9.0)).a * shadow_modulate.a) * 0.025372;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*10.0, shadow_radius*10.0)).a * shadow_modulate.a) * 0.023753;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*11.0, shadow_radius*11.0)).a * shadow_modulate.a) * 0.022083;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*12.0, shadow_radius*12.0)).a * shadow_modulate.a) * 0.020389;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*13.0, shadow_radius*13.0)).a * shadow_modulate.a) * 0.018695;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*14.0, shadow_radius*14.0)).a * shadow_modulate.a) * 0.017023;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*15.0, shadow_radius*15.0)).a * shadow_modulate.a) * 0.015393;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*16.0, shadow_radius*16.0)).a * shadow_modulate.a) * 0.013823;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*17.0, shadow_radius*17.0)).a * shadow_modulate.a) * 0.012327;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*18.0, shadow_radius*18.0)).a * shadow_modulate.a) * 0.010917;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*19.0, shadow_radius*19.0)).a * shadow_modulate.a) * 0.009602;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*20.0, shadow_radius*20.0)).a * shadow_modulate.a) * 0.008387;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*21.0, shadow_radius*21.0)).a * shadow_modulate.a) * 0.007274;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*22.0, shadow_radius*22.0)).a * shadow_modulate.a) * 0.006266;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*23.0, shadow_radius*23.0)).a * shadow_modulate.a) * 0.00536;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*24.0, shadow_radius*24.0)).a * shadow_modulate.a) * 0.004553;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*25.0, shadow_radius*25.0)).a * shadow_modulate.a) * 0.003841;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*26.0, shadow_radius*26.0)).a * shadow_modulate.a) * 0.003218;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*27.0, shadow_radius*27.0)).a * shadow_modulate.a) * 0.002678;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*28.0, shadow_radius*28.0)).a * shadow_modulate.a) * 0.002212;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*29.0, shadow_radius*29.0)).a * shadow_modulate.a) * 0.001815;
    shadow += vec4(shadow_modulate.rgb, texture(TEXTURE, pos_with_offset + ps * vec2(shadow_radius*30.0, shadow_radius*30.0)).a * shadow_modulate.a) * 0.001479;

    // apply gradient and shadow
    COLOR = mix(shadow, main_texture, main_texture.a);
}

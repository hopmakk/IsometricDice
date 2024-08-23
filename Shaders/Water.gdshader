shader_type canvas_item;

uniform sampler2D _noise1 : repeat_enable;
uniform sampler2D _noise2 : repeat_enable;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform vec2 _scroll1 = vec2(0.025, 0.01);
uniform vec2 _scroll2 = vec2(-0.005, -0.001);
uniform float _distortionStrength : hint_range(-1, 1) = 0.023;
uniform vec4 _toneColor : source_color;
uniform vec4 _topColor : source_color;
uniform float _lightStart : hint_range(0.0, 1.0) = 0.395;
uniform float _lightEnd : hint_range(0.0, 1.0) = 0.665;

void fragment() {
	float depth = texture(_noise1, UV + _scroll1 * TIME).r * texture(_noise2, UV + _scroll2 * TIME).r;
	vec4 screenCol = texture(SCREEN_TEXTURE, SCREEN_UV + _distortionStrength * vec2(depth));
	vec4 topLight = smoothstep(_lightStart, _lightEnd, depth) * _topColor;
	COLOR = screenCol * _toneColor + topLight;
	//COLOR.a = 1.0;
}

#pragma header

const int EFFECT_TYPE_DREAMY = 0;
const int EFFECT_TYPE_WAVY = 1;
const int EFFECT_TYPE_HEAT_WAVE_HORIZONTAL = 2;
const int EFFECT_TYPE_HEAT_WAVE_VERTICAL = 3;
const int EFFECT_TYPE_FLAG = 4;

uniform int uEffectType;
uniform float uTime;
uniform float uSpeed;
uniform float uFrequency;
uniform float uWaveAmplitude;

vec2 wave(vec2 uv)
{
	vec2 position = vec2(0.0, 0.0);

	if (uEffectType == EFFECT_TYPE_DREAMY)
		pt.x += sin(uv.y * uFrequency + uTime * uSpeed) * uWaveAmplitude;
	else if (uEffectType == EFFECT_TYPE_WAVY)
		pt.y += sin(uv.x * uFrequency + uTime * uSpeed) * uWaveAmplitude;
	else if (uEffectType == EFFECT_TYPE_HEAT_WAVE_HORIZONTAL)
		position.x = sin(uv.x * uFrequency + uTime * uSpeed) * uWaveAmplitude;
	else if (uEffectType == EFFECT_TYPE_HEAT_WAVE_VERTICAL)
		position.y = sin(uv.y * uFrequency + uTime * uSpeed) * uWaveAmplitude;
	else if (uEffectType == EFFECT_TYPE_FLAG)
	{
		position.x = sin(uv.x * uFrequency + 5.0 * uv.y + uTime * uSpeed) * uWaveAmplitude;
		position.y = sin(uv.y * uFrequency + 10.0 * uv.x + uTime * uSpeed) * uWaveAmplitude;
	}

	return vec2(uv.x + position.x, uv.y + position.y);
}

void main(void)
{
	gl_FragColor = texture2D(bitmap, wave(openfl_TextureCoordv));
}

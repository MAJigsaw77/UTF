#pragma header

const int EFFECT_TYPE_DREAMY = 0;
const int EFFECT_TYPE_WAVY = 1;
const int EFFECT_TYPE_HEAT_WAVE_HORIZONTAL = 2;
const int EFFECT_TYPE_HEAT_WAVE_VERTICAL = 3;
const int EFFECT_TYPE_FLAG = 4;

uniform int effectType;
uniform float uTime;
uniform float uSpeed;
uniform float uFrequency;
uniform float uWaveAmplitude;

vec2 sineWave(vec2 pt)
{
  float x = 0.0;
  float y = 0.0;

  if (effectType == EFFECT_TYPE_DREAMY)
  {
    pt.x += sin(pt.y * uFrequency + uTime * uSpeed) * uWaveAmplitude;
  }
  else if (effectType == EFFECT_TYPE_WAVY)
  {
    pt.y += sin(pt.x * uFrequency + uTime * uSpeed) * uWaveAmplitude;
  }
  else if (effectType == EFFECT_TYPE_HEAT_WAVE_HORIZONTAL)
  {
    x = sin(pt.x * uFrequency + uTime * uSpeed) * uWaveAmplitude;
  }
  else if (effectType == EFFECT_TYPE_HEAT_WAVE_VERTICAL)
  {
    y = sin(pt.y * uFrequency + uTime * uSpeed) * uWaveAmplitude;
  }
  else if (effectType == EFFECT_TYPE_FLAG)
  {
    y = sin(pt.y * uFrequency + 10.0 * pt.x + uTime * uSpeed) * uWaveAmplitude;
    x = sin(pt.x * uFrequency + 5.0 * pt.y + uTime * uSpeed) * uWaveAmplitude;
  }

  return vec2(pt.x + x, pt.y + y);
}

void main(void)
{
  gl_FragColor = texture2D(bitmap, sineWave(openfl_TextureCoordv));
}

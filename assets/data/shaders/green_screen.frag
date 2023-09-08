#pragma header

vec3 rgb2hsv(vec3 rgb)
{
  float Cmax = max(rgb.r, max(rgb.g, rgb.b));
  float Cmin = min(rgb.r, min(rgb.g, rgb.b));

  vec3 hsv = vec3(0., 0., Cmax);

  if (Cmax > Cmin)
  {
    float delta = Cmax - Cmin;

    hsv.y = delta / Cmax;

    if (rgb.r == Cmax)
      hsv.x = (rgb.g - rgb.b) / delta;
    else
    {
      if (rgb.g == Cmax)
        hsv.x = 2. + (rgb.b - rgb.r) / delta;
      else
        hsv.x = 4. + (rgb.r - rgb.g) / delta;
    }

    hsv.x = fract(hsv.x / 6.);
  }

  return hsv;
}

float chromaKey(vec3 color)
{
  return 1. - clamp(3. * length(vec3(6., 216. / 225., 1.) * (rgb2hsv(vec3(0., 1., 0.)) - rgb2hsv(color))) - 1.5, 0., 1.);
}

vec3 changeSaturation(vec3 color, float saturation)
{
  return mix(vec3(dot(vec3(0.213, 0.715, 0.072) * color, vec3(1.))), color, saturation);
}

void main(void)
{
  vec4 rColor = flixel_texture2D(bitmap, openfl_TextureCoordv);

  vec3 color = rColor.rgb * rColor.a;

  float incrustation = 1 - chromaKey(color);

  gl_FragColor = vec4(color * incrustation, incrustation);
}

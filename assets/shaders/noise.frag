#pragma header

uniform float uTime;
uniform float maxStrength; // 0.5
uniform float minStrength; // 0.125
uniform float speed; // 10.0

float random(vec2 noise)
{
	return fract(sin(dot(noise.xy, vec2(10.998, 98.233))) * 12433.14159265359);
}

void main(void)
{
	maxStrength = clamp(sin(uTime / 2.0), minStrength, maxStrength);

	vec3 colour = vec3(random(fract(openfl_TextureCoordv * fract(sin(uTime * speed))).xy)) * maxStrength;

	gl_FragColor = vec4(vec3(texture2D(bitmap, openfl_TextureCoordv)) - colour, 1.0);
}

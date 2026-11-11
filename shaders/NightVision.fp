vec3 HSLToRGB(in vec3 hsl)
{
    vec3 rgb = clamp(abs(mod(hsl.x * 6.0 + vec3(0.0, 4.0, 2.0), 6.0) - 3.0) - 1.0, 0.0, 1.0);

    return hsl.z + hsl.y * (rgb - 0.5) * (1.0 - abs(2.0 * hsl.z - 1.0));
}

void main()
{
	float exp = max(abs(exposure), 1.0);

	vec3 col = texture(InputTexture, TexCoord).rgb;

	// [Ace] Desaturate, fix levels, and colorize.
	col = mix(vec3(dot(col, vec3(0.5))), col, max(0.f, 0.5 - length(hsl.y)));
	col = pow(col, vec3(0.98)) * exp;
	col = clamp(pow(col * HSLToRGB(hsl), vec3(0.7)), 0.0, 1.0);

	// [Ace] Scanlines.
	col -= sin(TexCoord.y * 360.0 * 5.0 + timer * 0.75) * 0.04;

	FragColor = vec4(col, 1.0);
}
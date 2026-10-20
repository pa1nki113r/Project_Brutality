/*
   BlurSharpShift blur from MariENB
   (C)2012-2019 Marisa Kirisame

   Modified by m8f 2021 (made radius a constant).
*/
void main()
{
	vec2 coord = TexCoord;
	vec4 res = texture(InputTexture,coord);
	vec2 ofs[16] = vec2[]
	(
		vec2(1.0,1.0), vec2(-1.0,-1.0),
		vec2(-1.0,1.0), vec2(1.0,-1.0),

		vec2(1.0,0.0), vec2(-1.0,0.0),
		vec2(0.0,1.0), vec2(0.0,-1.0),

		vec2(1.41,0.0), vec2(-1.41,0.0),
		vec2(0.0,1.41), vec2(0.0,-1.41),

		vec2(1.41,1.41), vec2(-1.41,-1.41),
		vec2(-1.41,1.41), vec2(1.41,-1.41)
	);
	vec2 bresl = vec2(textureSize(InputTexture,0));
	float radius = 2.0;
	vec2 bof = radius/bresl;
	for ( int i=0; i<16; i++ ) res.rgb += texture(InputTexture,coord+ofs[i]*bof).rgb;
	res.rgb /= 17.0;
	FragColor = res;
}

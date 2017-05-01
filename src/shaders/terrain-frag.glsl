varying vec2 f_uv;
varying vec3 f_nor;
varying vec3 f_pos;

varying float f_elevation;
varying float f_moisture;

uniform vec3 ambientLight;
uniform vec3 lightVec;

vec3 biome_Banding(float e)
{
	//creates map with banding biomes
	vec3 LAND = vec3(0.698, 0.31, 0.118);
	vec3 WATER = vec3(0.0, 0.408, 0.847);
	vec3 BEACH = vec3(0.698, 0.31, 0.118);
	vec3 FOREST = vec3(0.698, 0.31, 0.118);
	vec3 JUNGLE = vec3(0.0313, 0.447, 0.149);
	vec3 BELOW_TUNDRA = vec3(0.709, 0.808, 0.608);
	vec3 TUNDRA = vec3(0.62, 0.886, 0.698);
	vec3 SNOW = vec3(0.9746, 0.9746, 0.9746);

	if (e < 0.1) return WATER;
	else if (e < 0.2) return BEACH;
	else if (e < 0.3) return FOREST;
	else if (e < 0.5) return JUNGLE;
	else if (e < 0.7) return BELOW_TUNDRA;
	else if (e < 0.9) return TUNDRA;
	else return SNOW;
}

vec3 biome_Gradient(float e, float m)
{
	vec3 OceanDark = vec3(35.0/255.0, 70.0/255.0, 175.0/255.0);
	vec3 OceanLight = vec3(47.0/255.0, 146.0/255.0, 252.0/255.0);

	vec3 Green = vec3(60.0/255.0, 133.0/255.0, 63.0/255.0);
	vec3 SuperLightGreen = vec3(189.0/255.0, 223.0/255.0, 190.0/255.0);
	vec3 Arid = vec3(218.0/255.0, 161.0/255.0, 87.0/255.0);
	vec3 SuperLightArid = vec3(226.0/255.0, 232.0/255.0, 247.0/255.0);

	vec3 finalcolor = vec3(0.0);

  	if (e < 0.15)
  	{
  		float t = e/0.15;
		finalcolor = (1.0-t)*OceanDark + t*OceanLight;
  	}
	else
	{
		float u = m;
		float v = e;

		vec3 colorbottom = (1.0-m)*Green + m*Arid;
		vec3 colortop = (1.0-m)*SuperLightGreen + m*SuperLightArid;

		finalcolor = (1.0-e)*colorbottom + e*colortop;
	}

  	return finalcolor;
}

void main()
{
    vec3 col = biome_Gradient(f_elevation, f_moisture);

    float absDot = clamp(dot(f_nor, normalize(f_pos -lightVec)), 0.0, 1.0);

    gl_FragColor = vec4( absDot*col, 1.0 );
}
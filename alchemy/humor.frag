
uniform float blood;
uniform float yellow_bile;
uniform float black_bile;
uniform float phlegm;

#define BLOOD_COLOR vec4(1, 0, 0, 0.5)

#define PROPERTY_SCALE 10

float rand(vec2 c){
	return fract(sin(dot(c.xy, vec2(12.9898,78.233))) * 43758.5453);
}

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    // sample the texture for this fragment
    vec4 textureColor = Texel(tex, texture_coords);
    // vec4 normalColor = Texel(normals, texture_coords);

    // light.direction - normal

    // return vec4(1, 0, 0, textureColor.a / 2) * color;

    // vec4 modulatedColor =  mix(BLOOD_COLOR * min(blood, PROPERTY_SCALE) / PROPERTY_SCALE;

    return normalize(textureColor + normalize(BLOOD_COLOR * min(blood, PROPERTY_SCALE) / PROPERTY_SCALE));
    // return normalize(mix(textureColor, BLOOD_COLOR, min(blood, PROPERTY_SCALE) / PROPERTY_SCALE));
}


uniform float blood;
uniform float yellow_bile;
uniform float black_bile;
uniform float phlegm;

uniform float u_time;

uniform Image maskTexture;

#define BLOOD_COLOR vec3(1, 0, 0)

#define PROPERTY_SCALE 10

float rand(vec2 c){
	return fract(sin(dot(c.xy, vec2(12.9898,78.233))) * 43758.5453);
}

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    vec4 textureColor = Texel(tex, texture_coords);
    vec4 mask = Texel(maskTexture, texture_coords);

    vec2 ipos = floor(texture_coords * 10);
    vec2 fpos = fract(texture_coords * 10);

    vec3 outColor = BLOOD_COLOR * vec3(rand(ipos)) * mask.rgb;

    return textureColor + (vec4(BLOOD_COLOR, 1.0) * mask);
    // return vec4(outColor, sin(fpos * u_time / 10));


    // vec4 highlight = mask * BLOOD_COLOR * min(blood, PROPERTY_SCALE) / PROPERTY_SCALE

    // return normalize(textureColor + normalize(highlight));
    // return normalize(mix(textureColor, BLOOD_COLOR, min(blood, PROPERTY_SCALE) / PROPERTY_SCALE));


}

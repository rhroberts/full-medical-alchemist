
uniform float blood;
uniform float yellow_bile;
uniform float black_bile;
uniform float phlegm;

#define BLOOD_COLOR vec4(1, 0, 0, 1)


vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    // sample the texture for this fragment
    // vec4 texturecolor = Texel(tex, texture_coords);
    // vec4 normalColor = Texel(normals, texture_coords);

    // light.direction - normal

    // return vec4(1, 0, 0, texturecolor.a / 2) * color;
    return color;
    // return texturecolor;
}
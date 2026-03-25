shader_type canvas_item;
uniform sampler2D Noise1:repeat_enable;
global uniform float MeanBrightness;

void vertex() {
	// Called for every vertex the material is visible on.
}

vec4 adj(vec4 Color) {
	float gamma = 3.0 - 2.0*MeanBrightness;
	float luminance = pow(max(max(Color.r,Color.g),Color.b),gamma);
	Color.r = (MeanBrightness*Color.r+pow(Color.r,gamma)/(luminance+1.0)+pow(Color.r,gamma));
	Color.g = (MeanBrightness*Color.g+pow(Color.g,gamma)/(luminance+1.0)+pow(Color.g,gamma));
	Color.b = (MeanBrightness*Color.b+pow(Color.b,gamma)/(luminance+1.0)+pow(Color.b,gamma));
	return Color;
}

void fragment() {
	//COLOR = texture(TEXTURE,vec2(UV.x+.02*sin(10.0*(TIME+UV.y)),UV.y));
	vec2 UV1 = UV;
	UV1.x = floor(UV1.x*256.0)/256.0;
	UV1.y = floor(UV1.y*64.0)/64.0;
	COLOR.r = 1.0;
	COLOR.g = 0.7*texture(Noise1,vec2((UV1.x-.5)*.5*(2.0-(.25*UV1.y))+.5,(.25*UV1.y)+0.2*TIME)).r;
	COLOR.b = 0.0;
	COLOR.a = 2.0*texture(Noise1,vec2(UV1.x,.25*UV1.y)/1.5+vec2(0,0.2*TIME)).r*(texture(TEXTURE,UV1).a+0.35*texture(TEXTURE,UV1+0.1*texture(Noise1,UV1+0.1*vec2(TIME)).rg).a);
	COLOR = adj(COLOR);
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}

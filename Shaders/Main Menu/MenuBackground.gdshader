shader_type canvas_item;
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
	vec2 UV1 = UV;
	UV1.x = floor(UV.x*64.0)/64.0;
	UV1.y = floor(UV.y*64.0)/64.0;
	float Distance = pow(SCREEN_UV.x-.5,2)+pow(SCREEN_UV.y-.5,2) + .2;
	if(COLOR.r > .75) {
		Distance = Distance/(4.0*COLOR.r-2.0);
	}
	COLOR.rg = COLOR.rg*(1.0-1.5*Distance/(Distance+1.0));
	COLOR.b = COLOR.b*(1.0-Distance/(Distance+1.0));
	COLOR = adj(COLOR);
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}

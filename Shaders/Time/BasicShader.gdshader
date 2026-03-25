shader_type canvas_item;
varying vec4 modulated_color;
global uniform float Time;
global uniform float MeanBrightness;

vec4 adj(vec4 Color) {
	float gamma = 3.0 - 2.0*MeanBrightness;
	float luminance = pow(max(max(Color.r,Color.g),Color.b),gamma);
	Color.r = (MeanBrightness*Color.r+pow(Color.r,gamma)/(luminance+1.0)+pow(Color.r,gamma));
	Color.g = (MeanBrightness*Color.g+pow(Color.g,gamma)/(luminance+1.0)+pow(Color.g,gamma));
	Color.b = (MeanBrightness*Color.b+pow(Color.b,gamma)/(luminance+1.0)+pow(Color.b,gamma));
	return Color;
}

void vertex() {
	// Called for every vertex the material is visible on.
	modulated_color = COLOR;
}

vec4 day(vec4 color)  {
	vec4 newcolor = color;
	newcolor = color*(min(1,max(0,color.b+color.g-color.r))/3.0+.75);
	return newcolor;
}
vec4 sunset(vec4 color) {
	vec4 newcolor = color;
	newcolor.r = 0.75*(color.r + max(color.b-color.r,0)*color.g);
	newcolor.g = 0.75*(.25*color.g);
	newcolor.b = 0.75*(1.25*color.b*(1.0-(2.0*color.g)));
	return newcolor;
}

vec4 night(vec4 color) {
	vec4 newcolor = color;
	newcolor.r = .05*color.r*(1.0+(0.5*color.b*color.g)-(0.5*color.b+.5*color.g));
	newcolor.g = .05*color.g*(1.0+(0.5*color.b*color.r)-(0.5*color.b+.5*color.r));
	newcolor.b = .05*color.b*(1.0+.5*color.r);
	return newcolor;
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 currentcolor = modulated_color*texture(TEXTURE,UV);
	vec4 daycolor = day(currentcolor);
	vec4 nightcolor = night(currentcolor);
	vec4 suncolor = sunset(currentcolor);
	float time = 0.0;
	float mtime = mod(Time*TAU/60.0,TAU);
	if(mtime<=1.5*PI) {
		time = mtime/1.5;
	}
	if(mtime>=1.5*PI) {
		time = 2.0*mtime;
	}
	float rsuncolor = 0.25*pow(1.0-(sin(time)*sin(time)),3);
	float rdaycolor = max((2.5*sin(time))-rsuncolor,0);
	float rnightcolor = max((-2.5*sin(time))-rsuncolor,0);
	float totalcolor = rsuncolor+rdaycolor+rnightcolor; 
	vec4 newcolor = (rdaycolor/totalcolor)*daycolor+(rnightcolor/totalcolor)*nightcolor+(rsuncolor/totalcolor)*suncolor;
	newcolor.a = currentcolor.a;
	COLOR = adj(newcolor);
}

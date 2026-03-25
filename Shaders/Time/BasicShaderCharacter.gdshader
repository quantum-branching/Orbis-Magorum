shader_type canvas_item;
varying vec4 modulated_color;
global uniform float Time;
global uniform float MeanBrightness;

void vertex() {
	// Called for every vertex the material is visible on.
	modulated_color = COLOR;
}
vec4 character(float colormod, vec4 color,vec4 newcolor){
	vec4 newcolor2 = newcolor;
	newcolor2.r = (0.25+.5*colormod)*color.r+.25*newcolor.r;
	newcolor2.g = (0.25+.5*colormod)*color.g+.25*newcolor.g;
	newcolor2.b = (0.25+.5*colormod)*color.b+.25*newcolor.b;
	return newcolor2;
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
	newcolor = character(0.75,color,newcolor);
	return newcolor;
}

vec4 night(vec4 color) {
	vec4 newcolor = color;
	newcolor.r = .125*color.r*(.75+(.25*color.r*color.g*color.b));
	newcolor.g = .125*color.g*(.75+(.25*color.r*color.g*color.b));
	newcolor.b = .125*color.b*(.75+(.25*color.r*color.g*color.b));
	newcolor = character(.5,color,newcolor);
	return newcolor;
}
void fragment() {
	// Called for every pixel the material is visible on.
	vec4 currentcolor = modulated_color*texture(TEXTURE,UV);
	currentcolor.rgb = currentcolor.rgb*pow(MeanBrightness+.5,2.0);
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
	COLOR = newcolor;
}

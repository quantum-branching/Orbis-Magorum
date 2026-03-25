shader_type canvas_item;
global uniform vec2 Pos;
uniform float Scale;
uniform sampler2D Map:filter_nearest;
uniform sampler2D Water:filter_nearest,repeat_enable;
uniform sampler2D Sand:filter_nearest,repeat_enable;
uniform sampler2D Grass:filter_nearest,repeat_enable;
uniform sampler2D Stone:filter_nearest,repeat_enable;
uniform sampler2D Encounter:repeat_enable;
global uniform float MeanBrightness;
global uniform float Time;

float ModTime(){
	float mtime = mod(Time*TAU/60.0,TAU);
	if(mtime<=1.5*PI) {
		return mtime/1.5;
	}
	if(mtime>=1.5*PI) {
		return 2.0*mtime;
	}
}

vec4 adj(vec4 Color) {
	float gamma = 3.0 - 2.0*MeanBrightness;
	float luminance = pow(max(max(Color.r,Color.g),Color.b),gamma);
	Color.r = (MeanBrightness*Color.r+pow(Color.r,gamma)/(luminance+1.0)+pow(Color.r,gamma));
	Color.g = (MeanBrightness*Color.g+pow(Color.g,gamma)/(luminance+1.0)+pow(Color.g,gamma));
	Color.b = (MeanBrightness*Color.b+pow(Color.b,gamma)/(luminance+1.0)+pow(Color.b,gamma));
	return Color;
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

vec4 tilemap(vec2 ScreenCoords) {
	vec4 Color = vec4(0,0,0,1);
	vec2 TexelUV = vec2(40.0*ScreenCoords.x,.75+22.5*ScreenCoords.y);
	vec2 MapPos = (vec2(40.0,22.5)*Scale*(ScreenCoords-vec2(.5))+Pos)+vec2(238,238);
	vec3 MeanColor = vec3(0);
	MapPos.x = floor(MapPos.x);
	MapPos.y = floor(MapPos.y);
	vec3 color = texture(Map,MapPos/vec2(476,476)).rgb;
	if(color.g<.25){
		Color.rgb = texture(Water,TexelUV-vec2(0,floor(16.0*TIME)/16.0)).rgb;
		MeanColor = vec3(0,0,.5);
	}
	if(color.g>.25&&color.g<.5){
		Color.rgb = texture(Sand,TexelUV).rgb;
		MeanColor = vec3(1,.75,0);
	}
	if(color.g>.5&&color.g<.75){
		Color.rgb = texture(Grass,TexelUV).rgb;
		MeanColor = vec3(.15,.4,.15);
	}
	if(color.g>.75){
		Color.rgb = texture(Stone,TexelUV).rgb;
		MeanColor = vec3(.4,.4,.4);
	}
	if(texture(Encounter,MapPos/vec2(128)).r<.25 && color.g<.75 && color.g>.25 && color.b > .1){
		Color.rgb = 2.0*(Color.rgb-MeanColor)+MeanColor;
	}
	return Color;
}

vec4 DayCycle(vec4 Color){
	vec4 daycolor = day(Color);
	vec4 nightcolor = night(Color);
	vec4 suncolor = sunset(Color);
	float time = ModTime();
	float rsuncolor = 0.25*pow(1.0-(sin(time)*sin(time)),3);
	float rdaycolor = max((2.5*sin(time))-rsuncolor,0);
	float rnightcolor = max((-2.5*sin(time))-rsuncolor,0);
	float totalcolor = rsuncolor+rdaycolor+rnightcolor; 
	Color = (rdaycolor/totalcolor)*daycolor+(rnightcolor/totalcolor)*nightcolor+(rsuncolor/totalcolor)*suncolor;
	Color.a = Color.a;
	return Color;
}

void fragment() {
	//COLOR = tilemap(UV);
	COLOR = adj(DayCycle(tilemap(UV)));
}

shader_type canvas_item;
global uniform vec4 SkinColor;
global uniform vec4 HairColor;
global uniform vec4 HatColor;
global uniform vec4 ChestColor;
global uniform vec4 BootColor;
global uniform vec4 ScaleraColor;
global uniform vec4 IrisColor;
global uniform int ArmorType;
global uniform int Swap;

uniform vec4 HatColorOverride:source_color = vec4(0);
uniform vec4 ChestColorOverride:source_color = vec4(0);
uniform vec4 BootColorOverride:source_color = vec4(0);
uniform int ArmorTypeOverride = -1;

vec4 plate(vec4 color) {
	vec4 newcolor = color;
	float maxval = max(max(color.r,color.g),color.b);
	newcolor.r = .125*color.r/maxval+maxval;
	newcolor.g = .125*color.g/maxval+maxval;
	newcolor.b = .125*color.b/maxval+maxval;
	return newcolor;
}

vec4 mail(vec4 color) {
	vec4 newcolor = color;
	float maxval = max(max(color.r,color.g),color.b);
	newcolor.r = (color.r+1.5*maxval)/5.0;
	newcolor.g = (color.g+1.5*maxval)/5.0;
	newcolor.b = (color.b+1.5*maxval)/5.0;
	return newcolor;
}

vec4 leather(vec4 color) {
	vec4 newcolor = color;
	newcolor.r = .85*color.r+.35*color.g+.35*color.b;
	newcolor.g = .65*color.g;
	newcolor.b = .65*color.b;
	return newcolor;
}

vec4 cloth(vec4 color) {
	vec4 newcolor = color;
	float minval = min(min(color.r,color.g),color.b);
	float maxval = max(max(color.r,color.g),color.b);
	newcolor.r = 1.15*((color.r-minval)/(maxval-minval));
	newcolor.g = 1.15*((color.g-minval)/(maxval-minval));
	newcolor.b = 1.15*((color.b-minval)/(maxval-minval));
	return newcolor;
}

bool approx(float a,float b) {
	bool result = false;
	if(abs(a-b)<4.0) {
		result = true;
	}
	return result;
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 Color = COLOR;
	int ArmorClass = ArmorType;
	if(ArmorTypeOverride!=-1){
		ArmorClass = ArmorTypeOverride;
	}
	Color.rgb = 255.0*Color.rgb;
	if(Color.r>250.0){
		Color.rg = 255.0*texture(TEXTURE,vec2(1.0-UV.x,UV.y)).rg;
	}
	if(Color.r<100.0) {
		if(approx(Color.r,0.0)) {
			COLOR = SkinColor;
			ArmorClass = -1;
			}
		if(approx(Color.r,32.0)) {
			COLOR = HairColor;
			ArmorClass = -1;
			}
		if(approx(Color.r,64.0)) {
			if(HatColorOverride.a>.99){
				COLOR = HatColorOverride;
			}
			else {COLOR = HatColor;}
			}
		if(approx(Color.r,96.0)) {
			if(ChestColorOverride.a>.99){
				COLOR = ChestColorOverride;
			}
			else {COLOR = ChestColor;}
			}
		}
		else {
			if(approx(Color.r,128.0)) {
			if(BootColorOverride.a>.99) {COLOR = BootColorOverride;}
			else {COLOR = BootColor;}
			}
		if(approx(Color.r,160.0)) {
			COLOR = ScaleraColor;
			ArmorClass = -1;
			}
		if(approx(Color.r,192.0)) {
			COLOR = IrisColor;
			ArmorClass = -1;
			}
	}
	if(ArmorClass==0) {
		COLOR = SkinColor;
		if(approx(Color.r,64.0)) {
			Color.a = 0.0;
		}
		Color.g = 196.0+Color.g/4.0;
	}
	if(ArmorClass==1) {
		//Cloth
		COLOR = cloth(COLOR);
		}
	if(ArmorClass==2) {
		//Leather
		COLOR = leather(COLOR);
		}
	if(ArmorClass==3) {
		//Mail
		COLOR = mail(COLOR);
		}
	if(ArmorClass==4) {
		//Plate
		COLOR = plate(COLOR);
		}
	COLOR.rgb = COLOR.rgb*Color.g/255.0;
	COLOR.a = Color.a;
	if(Color.b > 250.0 && Swap == 1) {
		COLOR.a = 0.0;
	}
	if(Color.b < 133.0 && Color.b > 123.0 && Swap == 2) {
		COLOR.a = 0.0;
	}
	if(Color.b < 69.0 && Color.b > 59.0 && Swap != 1) {
		COLOR.a = 0.0;
	}
}

void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
}

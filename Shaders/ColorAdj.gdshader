shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

vec4 adj(vec4 Color) {
	float gamma = 2.0;
	float luminance = pow(max(max(Color.r,Color.g),Color.b),gamma);
	float brightness = .5;
	//Reinhard Tone Mapping
	Color.r = (brightness*Color.r+pow(Color.r,gamma)/(luminance+1.0)+pow(Color.r,gamma));
	Color.g = (brightness*Color.g+pow(Color.g,gamma)/(luminance+1.0)+pow(Color.g,gamma));
	Color.b = (brightness*Color.b+pow(Color.b,gamma)/(luminance+1.0)+pow(Color.b,gamma));
	return Color;
}

void fragment() {

}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}

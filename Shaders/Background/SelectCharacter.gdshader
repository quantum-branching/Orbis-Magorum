shader_type canvas_item;
uniform sampler2D noise:repeat_enable;

void fragment() {
	if(UV.y<5.0/9.0){
		COLOR.r = 3.0*(.5-UV.y)*texture(noise,UV-vec2(.05*TIME,0.0)).r;
	} else {
		COLOR.rb = vec2(0);
		COLOR.g = .375;
	}
	COLOR.rgb = COLOR.rgb;
}

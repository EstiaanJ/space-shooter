shader_type canvas_item;
void fragment() {
    vec4 color = texture(TEXTURE, UV);
    
	color.a = 0.5;
    // Make black pixels transparent
    if (color.r < 0.1 && color.g < 0.1 && color.b < 0.1) {
        color.a = 0.0;
    }
	

        

    
    COLOR = color;
}
void vertex() {
	// Called for every vertex the material is visible on.
}



//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}

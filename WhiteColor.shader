shader_type canvas_item;

uniform bool active = false;

void fragment() {
    vec4 previous_color = texture(TEXTURE, UV);
    
    // Passing in previous_color.a (the alpha value of that color) as the final 
    // value here will allow it to say "Make it white while on the player, but not around the player"
    vec4 white_color = vec4(1.0, 1.0, 1.0, previous_color.a);
    vec4 new_color = previous_color;
    if (active == true) {
        new_color = white_color;    
    }
    COLOR = new_color;    
}
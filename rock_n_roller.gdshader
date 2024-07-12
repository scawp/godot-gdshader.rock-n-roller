shader_type canvas_item;

group_uniforms general;
uniform vec2 pivotPoint = vec2(0.0, 0.0);

group_uniforms rock;
uniform float enableRock: hint_range(0.0, 1.0, 0.05) = 0.0;
uniform float angleRock: hint_range(0.0, 360, 1.0) = 45.0; //Degrees
uniform float hzRock: hint_range(0.0, 5.0, 0.05) = 1.0;

group_uniforms roll;
uniform float enableRoll: hint_range(0.0, 1.0, 0.05) = 0.0;
uniform float radiusRoll: hint_range(0.0, 640.0, 0.5) = 100.0; //pixels
uniform float hzRoll: hint_range(-5.0, 5.0, 0.05) = 1.0; //negitive for anti-clockwise

group_uniforms bounce;
uniform float enableBounce: hint_range(0.0, 1.0, 0.05) = 0.0;
uniform float scaleBounce: hint_range(0.0, 400.0, 0.5) = 100.0; //100% = 1:1, 200% = 2:1, 50% = 1:2 etc
uniform float hzBounce: hint_range(0.0, 5.0, 0.05) = 1.0;

group_uniforms fade;
uniform float fadeOut: hint_range(0.0, 1.0, 0.05) = 1.0;

group_uniforms advanced;
uniform bool timeOveride = false;
uniform float phase = 0.0;

group_uniforms other;
uniform bool multiColour = false;
uniform vec3 borderColour: source_color = vec3(0.0);

float getTime() {
	//return phase;
	return timeOveride ? phase * PI * 2.0 : (TIME * PI * 2.0);
	//return timeOveride ? (phase * PI * 2.0) : (TIME * PI * 2.0);
}

vec2 rotate(vec2 vec, vec2 centre, float angle) {
	vec -= centre;
	vec *= mat2(vec2(cos(angle), sin(angle)),
				vec2(-sin(angle), cos(angle))
	);
	return vec += centre;
}

void vertex() {
	vec2 offset = vec2(0.0, 0.0);
	
	if (enableRoll > 0.0) {
		offset = vec2(sin(getTime() * hzRoll) * (radiusRoll * enableRoll),
					-cos(getTime() * hzRoll) * (radiusRoll * enableRoll));
		VERTEX += offset;
	}
	
	if (enableRock > 0.0 && angleRock > 0.0) {
		VERTEX = rotate(VERTEX, pivotPoint + offset, sin(getTime() * hzRock) * (PI / 360.0 * angleRock) * enableRock);
	}
	
	if (enableBounce > 0.0) {
		VERTEX += vec2(abs(sin(getTime() * hzBounce)) * (VERTEX.x - pivotPoint.x), 
					   abs(sin(getTime() * hzBounce)) * (VERTEX.y - pivotPoint.y)
				) * ((scaleBounce / 100.0) - 1.0) * enableBounce ; //100% = 1:1, 200% = 2:1, 50% = 1:2 etc
	}
}

void fragment() {
	//TODO: Make this customisable
	if (multiColour) {
		if (COLOR.rgb != borderColour) {
			COLOR.b -= sin(getTime() / 2.0);
			COLOR.g -= cos(getTime() / 3.0);
			COLOR.r += cos(getTime() / 2.5);
		}
	}
	
	//fadeout
	if(COLOR.a > 0.0) {
		COLOR.a -= 1.0 - clamp(fadeOut, 0.0, 1.0);
	}
}
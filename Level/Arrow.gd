class_name Arrow
extends Line2D

var follow_mouse: bool = true

func _ready():
	add_point(Vector2(0, 0), 0)
	add_point(Vector2(0, 0), 1)

func _process(delta):
	if (follow_mouse):
		set_point_position(1, get_local_mouse_position())
	
func attach_to_mouse():
	follow_mouse = true;
	
func detach_from_mouse(end_attach_point: Vector2):
	set_point_position(1, to_local(end_attach_point))
	follow_mouse = false

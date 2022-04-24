class_name Arrow
extends Line2D

enum FollowTarget {
	MOUSE, GEM
}

var follow_target: FollowTarget
var gem: Gem

func _ready():
	add_point(Vector2(0, 0), 0)
	add_point(Vector2(0, 0), 1)

func _process(delta):
	match follow_target:
		FollowTarget.MOUSE:
			set_point_position(1, get_local_mouse_position())
		FollowTarget.GEM:
			set_point_position(1, gem.position - global_position)
		_: pass
	
func attach_to_mouse() -> void:
	follow_target = FollowTarget.MOUSE

func attach_to_gem(gem: Gem) -> void:
	self.gem = gem
	follow_target = FollowTarget.GEM
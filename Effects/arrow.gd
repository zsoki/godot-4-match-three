class_name Arrow
extends Line2D


enum FollowTarget {
	NONE, MOUSE, GEM
}

var _follow_target: FollowTarget
var _gem: Gem


func _ready():
	add_point(Vector2(0, 0), 0)
	add_point(Vector2(0, 0), 1)


func _process(delta):
	match _follow_target:
		FollowTarget.MOUSE:
			set_point_position(1, get_local_mouse_position())
		FollowTarget.GEM:
			if _gem == null:
				_follow_target = FollowTarget.NONE
			set_point_position(1, _gem.position - global_position)
		_: pass

	
func attach_to_mouse() -> void:
	_follow_target = FollowTarget.MOUSE


func attach_to_gem(gem: Gem) -> void:
	_gem = gem
	_follow_target = FollowTarget.GEM

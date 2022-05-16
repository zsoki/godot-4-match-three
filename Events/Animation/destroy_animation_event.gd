class_name DestroyAnimationEvent
extends AnimationEvent


var _destroy_gems: Array[Gem]


func _init(destroy_gems: Array[Gem]):
	_destroy_gems = destroy_gems


func play_animation() -> void:
	for gem in _destroy_gems:
		gem.destroy()
	_destroy_gems.clear()

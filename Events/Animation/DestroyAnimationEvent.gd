class_name DestroyAnimationEvent extends AnimationEvent

var destroy_gems: Array[Gem]

func _init(destroy_gems: Array[Gem]):
	self.destroy_gems = destroy_gems


func play() -> void:
	for gem in destroy_gems:
		gem.destroy()
	destroy_gems.clear()

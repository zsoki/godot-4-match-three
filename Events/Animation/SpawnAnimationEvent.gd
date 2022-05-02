class_name SpawnAnimationEvent extends AnimationEvent

var spawn_gem: Gem

func _init(spawn_gem: Gem):
	self.spawn_gem = spawn_gem


func play() -> void:
	spawn_gem.spawn()

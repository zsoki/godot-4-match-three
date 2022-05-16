class_name SpawnAnimationEvent
extends AnimationEvent


var _spawn_gem: Gem


func _init(spawn_gem: Gem):
	_spawn_gem = spawn_gem


func play_animation() -> void:
	_spawn_gem.spawn()

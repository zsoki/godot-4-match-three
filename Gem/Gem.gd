class_name Gem
extends Node2D


@export var gem_types: Array[GemType]
@export var gem_sprite: Sprite2D
@export var animation_player: AnimationPlayer

var type: GemType


func _ready():
	var acc_weights: Array[float]
	var total_weight := 0.0
	
	for gem_type in gem_types:
		total_weight += gem_type.spawn_chance_weight
		acc_weights.append(total_weight)

	var roll := randf_range(0.0, total_weight)
	if (gem_types.size() > 0):
		for type_index in range(0, gem_types.size()):
			if acc_weights[type_index] > roll:
				type = gem_types[type_index]
				break
		gem_sprite.texture = type.texture


func spawn() -> void:
	animation_player.play("Spawn")
	while await animation_player.animation_finished != "Spawn":
		pass


func destroy() -> void:
	animation_player.play("Destroy")
	while await animation_player.animation_finished != "Destroy":
		pass
	queue_free()

class_name Gem
extends Node2D


@export var gem_type_resource: Array[Resource]

var type: GemType

@onready var gem_sprite: Sprite2D = $GemSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready():
	var gem_types: Array[GemType]
	var acc_weights: Array[float]
	var total_weight := 0.0
	
	for resource in gem_type_resource:
		var gem_type := resource as GemType
		total_weight += gem_type.weight
		gem_types.append(gem_type)
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

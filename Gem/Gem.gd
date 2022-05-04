class_name Gem
extends Node2D


@export var gem_type_resource: Array[Resource]

var type: GemType

@onready var gem_sprite: Sprite2D = $GemSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready():
	var gem_types: Array[Resource]
	for res in gem_type_resource: gem_types.append(res)

	if (gem_types.size() > 0):
		type = gem_types[randi() % gem_types.size()]
		gem_sprite.modulate = type.color


func spawn() -> void:
	animation_player.play("Spawn")
	while await animation_player.animation_finished != "Spawn":
		pass


func destroy() -> void:
	animation_player.play("Destroy")
	while await animation_player.animation_finished != "Destroy":
		pass
	queue_free()

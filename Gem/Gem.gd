class_name Gem
extends Node2D

@export var gem_type_resource: Array[Resource]
var gem_types: Array[Resource]
var type: GemType

@export_node_path(Sprite2D) var _gem_sprite
@onready var gem_sprite: Sprite2D = get_node(_gem_sprite)

@export_node_path(AnimationPlayer) var _destroy_animation
@onready var destroy_animation: AnimationPlayer = get_node(_destroy_animation)
	
func _ready():
	for res in gem_type_resource: gem_types.append(res)
	if (gem_types.size() > 0):
		type = gem_types[randi() % gem_types.size()]
		gem_sprite.modulate = type.color

func destroy() -> void:
	destroy_animation.play("Destroy")
	var animation: String = await destroy_animation.animation_finished
	if animation == "Destroy":
		queue_free()

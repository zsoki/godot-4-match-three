class_name Gem
extends Node2D

@export var gem_type_resource: Array[Resource]
var gem_types: Array[Resource]
var type: GemType

@export_node_path(Sprite2D) var _gem_sprite
@onready var gem_sprite: Sprite2D = get_node(_gem_sprite)

@export_node_path(AnimationPlayer) var _animation_player
@onready var animation_player: AnimationPlayer = get_node(_animation_player)
	
func _ready():
	for res in gem_type_resource: gem_types.append(res)
	if (gem_types.size() > 0):
		type = gem_types[randi() % gem_types.size()]
		gem_sprite.modulate = type.color

func spawn() -> void:
	animation_player.play("Spawn")
	await animation_player.animation_finished

func destroy() -> void:
	animation_player.play("Destroy")
	var animation: String = await animation_player.animation_finished
	if animation == "Destroy":
		queue_free()

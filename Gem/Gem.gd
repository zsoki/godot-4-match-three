class_name Gem
extends Node2D

@export var gem_type_resource: Array[Resource]
var gem_types: Array[Resource]
var type: GemType

@export_node_path(Sprite2D) var _gem_sprite
var gem_sprite: Sprite2D
	
func _ready():
	gem_sprite = get_node(_gem_sprite)
	
	for res in gem_type_resource: gem_types.append(res)
	if (gem_types.size() > 0):
		type = gem_types[randi() % gem_types.size()]
		gem_sprite.modulate = type.color

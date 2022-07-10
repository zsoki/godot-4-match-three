class_name ScoreLabel
extends Node2D


@export var score_label: Label
@export var animation_player: AnimationPlayer


func _ready():
	visible = false


func play_animation(score: int, color: Color) -> void:
	visible = true
	score_label.text = "%s" % score
	score_label.add_theme_color_override("font_outline_color", color)
	animation_player.play("Pop")
	while await animation_player.animation_finished != "Pop":
		pass
	queue_free()

class_name ScoreLabel
extends Node2D


@onready var score_label: Label = $ScoreLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready():
	visible = false


func play_animation(score: int) -> void:
	visible = true
	score_label.text = "%s" % score
	animation_player.play("Pop")
	while await animation_player.animation_finished != "Pop":
		pass
	queue_free()

class_name ScoreAnimationEvent
extends AnimationEvent


var _game_manager: GameManager
var _cell_to_gem_type: Dictionary


func _init(game_manager: GameManager, cell_to_gem_type: Dictionary):
	_game_manager = game_manager
	_cell_to_gem_type = cell_to_gem_type


func play_animation() -> void:
	for cell in _cell_to_gem_type:
		var score_label: ScoreLabel = _game_manager.score_scene.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
		score_label.position = cell.position
		_game_manager.score_parent.add_child(score_label)
		var gem_type: GemType = _cell_to_gem_type[cell]
		score_label.play_animation(gem_type.score, gem_type.color)

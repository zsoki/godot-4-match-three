class_name ScoreAnimationEvent
extends AnimationEvent


var _game_manager: GameManager
var _cell_to_score: Dictionary


func _init(game_manager: GameManager, cell_to_score: Dictionary):
	_game_manager = game_manager
	_cell_to_score = cell_to_score


func play_animation() -> void:
	for cell in _cell_to_score:
		var score: ScoreLabel = _game_manager.score_scene.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
		score.position = cell.position
		_game_manager.score_parent.add_child(score)
		score.play_animation(_cell_to_score[cell])

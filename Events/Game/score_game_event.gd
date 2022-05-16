class_name ScoreGameEvent
extends GameEvent


var _game_manager: GameManager
var _matched_cell_sets: Array = []
var _cell_to_match_set: Dictionary = {}


func _init(game_manager: GameManager, matched_cell_sets: Array, cell_to_match_set: Dictionary):
	_game_manager = game_manager
	_matched_cell_sets = matched_cell_sets
	_cell_to_match_set = cell_to_match_set


func run_game_event() -> void:
	var score_sum: int
	var cell_to_gem_type: Dictionary = {}
	
	for matched_set in _matched_cell_sets:
		for element in matched_set:
			var cell: Cell = element
			score_sum += cell.gem.type.score
			cell_to_gem_type[cell] = cell.gem.type
	
	_game_manager.increase_score(score_sum)
	_game_manager.animation_event_queue.push_front(ScoreAnimationEvent.new(_game_manager, cell_to_gem_type))

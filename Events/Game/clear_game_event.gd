class_name ClearGameEvent
extends GameEvent


var _game_manager: GameManager
var _matched_cell_sets: Array = []
var _cell_to_match_set: Dictionary = {}


func _init(game_manager: GameManager, matched_cell_sets: Array, cell_to_match_set: Dictionary):
	_game_manager = game_manager
	_matched_cell_sets = matched_cell_sets
	_cell_to_match_set = cell_to_match_set


func run_game_event() -> void:
	var destroy_gems: Array[Gem]
	
	for cell in _cell_to_match_set.keys():
		destroy_gems.append(cell.gem)
		cell.gem = null
		print("Destroyed cell at %s" % cell.coord)
	
	_game_manager.animation_event_queue.push_front(DestroyAnimationEvent.new(destroy_gems))
	_game_manager.game_event_queue.push_front(DropGameEvent.new(_game_manager))

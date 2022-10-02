class_name SpawnGameEvent
extends GameEvent


var _game_manager: GameManager


func _init(game_manager: GameManager):
	_game_manager = game_manager

func run_game_event() -> void:
	var composite_animation_event := CompositeAnimationEvent.new()
	var board_size := _game_manager.board_size
	var coord_to_cell := _game_manager.coord_to_cell
	
	for col in board_size.x:
		for row in range(-board_size.y, board_size.y - 1, 1):
			var coord := Vector2i(col, row)
			var cell: Cell = coord_to_cell[coord]
			if cell.gem == null:
				var gem: Gem = _game_manager.instantiate_gem(cell)
				composite_animation_event.add(SpawnAnimationEvent.new(gem))
	
	_game_manager.animation_event_queue.push_front(composite_animation_event)
	_game_manager.game_event_queue.push_front(MatchGameEvent.new(_game_manager))


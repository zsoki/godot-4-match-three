class_name DropGameEvent
extends GameEvent


var _game_manager: GameManager


func _init(game_manager: GameManager):
	_game_manager = game_manager


func run_game_event() -> void:
	var drop_animation_event := CompositeAnimationEvent.new()
	var board_size := _game_manager.board_size
	var coord_to_cell := _game_manager.coord_to_cell
	
	for col in board_size.x:
		for row in range(board_size.y - 1, -board_size.y, -1):
			var coord := Vector2i(col, row)
			var empty_cell: Cell = coord_to_cell[coord]
			
			if empty_cell.gem == null:
				var replace_row := row
				
				while not replace_row <= -board_size.y:
					replace_row -= 1
					var replace_coord := Vector2i(col, replace_row)
					var replace_cell: Cell = coord_to_cell[replace_coord]
					if replace_cell.gem == null:
						continue
					
					empty_cell.gem = replace_cell.gem
					replace_cell.gem = null
					drop_animation_event.add(DropAnimationEvent.new(empty_cell.gem, empty_cell))
					break
	
	_game_manager.animation_event_queue.push_front(drop_animation_event)
	_game_manager.game_event_queue.push_front(SpawnGameEvent.new(_game_manager))

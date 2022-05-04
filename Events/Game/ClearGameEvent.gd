class_name ClearGameEvent
extends GameEvent


# TODO configurable
const REQUIRED_CONSEQUENT_FOR_MATCH: int = 3

var _game_manager: GameManager


func _init(game_manager: GameManager):
	_game_manager = game_manager


func run_game_event() -> void:
	var matched_cells: Array[Cell]
	var board_size := _game_manager.board_size
	var coord_to_cell := _game_manager.coord_to_cell
	
#	Iterate through rows
	for row in board_size.y:
		var consequent_type: GemType = null
		var consequent_cells: Array[Cell]

		for col in board_size.x:
			var cell: Cell = coord_to_cell[Vector2i(col, row)]

			if cell.gem.type == consequent_type:
				consequent_cells.append(cell)
				if col == board_size.x - 1:
					_handle_match(consequent_cells, matched_cells, cell)
			else:
				consequent_type = _handle_match(consequent_cells, matched_cells, cell)
	
#	Iterate through columns
	for col in board_size.x:
		var consequent_type: GemType = null
		var consequent_cells: Array[Cell]

		for row in board_size.y:
			var cell: Cell = coord_to_cell[Vector2i(col, row)]

			if cell.gem.type == consequent_type:
				consequent_cells.append(cell)
				if row == board_size.y - 1:
					_handle_match(consequent_cells, matched_cells, cell)
			else:
				consequent_type = _handle_match(consequent_cells, matched_cells, cell)
	
	var destroy_gems: Array[Gem]
	
	for cell in matched_cells:
		destroy_gems.append(cell.gem)
		cell.gem = null
		print("Destroyed cell at %s" % cell.coord)

	if destroy_gems.size() != 0:
		_game_manager.animation_event_queue.push_front(DestroyAnimationEvent.new(destroy_gems))
		_game_manager.game_event_queue.push_front(DropGameEvent.new(_game_manager))


func _handle_match(consequent_cells: Array[Cell], matched_cells: Array[Cell], cell: Cell) -> GemType:
	if consequent_cells.size() >= REQUIRED_CONSEQUENT_FOR_MATCH:
		for cons_cell in consequent_cells: matched_cells.append(cons_cell)
	consequent_cells.clear()
	consequent_cells.append(cell)
	return cell.gem.type


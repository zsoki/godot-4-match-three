class_name MatchGameEvent
extends GameEvent


var _game_manager: GameManager
var _matched_cell_sets: Array
var _cell_to_match_set: Dictionary


func _init(game_manager: GameManager, matched_cell_sets: Array, cell_to_match_set: Dictionary):
	_game_manager = game_manager
	_matched_cell_sets = matched_cell_sets
	_cell_to_match_set = cell_to_match_set


func run_game_event() -> void:
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
					_handle_match(consequent_cells, cell)
			else:
				consequent_type = _handle_match(consequent_cells, cell)
	
#	Iterate through columns
	for col in board_size.x:
		var consequent_type: GemType = null
		var consequent_cells: Array[Cell]

		for row in board_size.y:
			var cell: Cell = coord_to_cell[Vector2i(col, row)]

			if cell.gem.type == consequent_type:
				consequent_cells.append(cell)
				if row == board_size.y - 1:
					_handle_match(consequent_cells, cell)
			else:
				consequent_type = _handle_match(consequent_cells, cell)


	if _matched_cell_sets.size() != 0:
		_game_manager.game_event_queue.push_front(ScoreGameEvent.new(_game_manager, _matched_cell_sets, _cell_to_match_set))
		_game_manager.game_event_queue.push_front(ClearGameEvent.new(_game_manager, _matched_cell_sets, _cell_to_match_set))


func _handle_match(consequent_cells: Array[Cell], cell: Cell) -> GemType:
	if consequent_cells.size() >= _game_manager.required_cells_for_match:
		var matched_cells_dupe: Array[Cell] = consequent_cells.duplicate()
		_matched_cell_sets.append(matched_cells_dupe)
		for cons_cell in consequent_cells:
			_cell_to_match_set[cons_cell] = matched_cells_dupe
		
	consequent_cells.clear()
	consequent_cells.append(cell)
	return cell.gem.type


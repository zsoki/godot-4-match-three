class_name ExplodeGameEvent
extends GameEvent


const EXPLODE_RADIUS: int = 1


var _game_manager: GameManager
var _to_cell: Cell
var _matched_cell_sets: Array = []
var _cell_to_match_set: Dictionary = {}


func _init(game_manager: GameManager, to_cell: Cell):
	_game_manager = game_manager
	_to_cell = to_cell


func run_game_event() -> void:
	var board_size := _game_manager.board_size
	var coord_to_cell := _game_manager.coord_to_cell
	
	if _to_cell.gem.type.name == "Bomb":
		var exploded_cells: Dictionary = explode(_to_cell.coord, board_size, coord_to_cell, {})
		_matched_cell_sets.append(exploded_cells.keys())
	
	_game_manager.game_event_queue.push_front(MatchGameEvent.new(_game_manager, _matched_cell_sets, _cell_to_match_set))


func explode(coord: Vector2i, board_size: Vector2i, coord_to_cell: Dictionary, exploded_cells: Dictionary) -> Dictionary:
	for expl_col in range(max(coord.x - EXPLODE_RADIUS, 0), min(coord.x + EXPLODE_RADIUS, board_size.x - 1) + 1):
		for expl_row in range(max(coord.y - EXPLODE_RADIUS, 0), min(coord.y + EXPLODE_RADIUS, board_size.y - 1) + 1):
			
			var exploded_cell: Cell = coord_to_cell[Vector2i(expl_col, expl_row)]
			print("Checking %s cell for explosion" % exploded_cell.coord)
			if not exploded_cells.has(exploded_cell):
				exploded_cells[exploded_cell] = true
				_cell_to_match_set[exploded_cell] = exploded_cells
				if exploded_cell.gem.type.name == "Bomb":
					explode(exploded_cell.coord, board_size, coord_to_cell, exploded_cells)
	return exploded_cells

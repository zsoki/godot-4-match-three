class_name ClearGameEvent extends GameEvent

# TODO configurable
const required_consequent_for_match: int = 3

var board_size: Vector2i
var coord_to_cell: Dictionary
var game_event_queue: Array[GameEvent]
var animation_event_queue: Array[AnimationEvent]

func _init(board_size: Vector2i, coord_to_cell: Dictionary,
	game_event_queue: Array[GameEvent], animation_event_queue: Array[AnimationEvent]):
	self.board_size = board_size
	self.coord_to_cell = coord_to_cell
	self.game_event_queue = game_event_queue
	self.animation_event_queue = animation_event_queue

func run() -> void:
	var matched_cells: Array[Cell]
	
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
	
#	Iterate through cols
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

	animation_event_queue.push_front(DestroyAnimationEvent.new(destroy_gems))
	

func _handle_match(consequent_cells: Array[Cell], matched_cells: Array[Cell], cell: Cell) -> GemType:
	if consequent_cells.size() >= required_consequent_for_match:
		for cons_cell in consequent_cells: matched_cells.append(cons_cell)
	consequent_cells.clear()
	consequent_cells.append(cell)
	return cell.gem.type


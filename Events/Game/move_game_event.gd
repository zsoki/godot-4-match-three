class_name MoveGameEvent
extends GameEvent


var _game_manager: GameManager


func _init(game_manager: GameManager):
	_game_manager = game_manager


func run_game_event() -> void:
	var selected_cells := _game_manager.selected_cells
	var from_cell: Cell = selected_cells.pop_back()
	var to_cell: Cell = selected_cells.pop_back()
	
	from_cell.selected = false
	to_cell.selected = false

	var moved_gem := from_cell.gem

	var from_col_range: Array[int]
	var from_row_range: Array[int]
	var to_col_range: Array[int]
	var to_row_range: Array[int]
	
	var direction: Vector2i = (to_cell.coord - from_cell.coord).clamp(Vector2i(-1, -1), Vector2i(1, 1))
	match direction:
		Vector2i.RIGHT:
			from_col_range = range(from_cell.coord.x + 1, to_cell.coord.x + 1)
			for from_col in from_col_range: to_col_range.append(from_col - 1)
			continue
		Vector2i.LEFT:
			from_col_range = range(from_cell.coord.x - 1, to_cell.coord.x - 1, -1)
			for from_col in from_col_range: to_col_range.append(from_col + 1)
			continue
		Vector2i.RIGHT, Vector2i.LEFT:
			for i in from_col_range.size():
				from_row_range.append(from_cell.coord.y)
				to_row_range.append(from_cell.coord.y)
		Vector2i.DOWN:
			from_row_range = range(from_cell.coord.y + 1, to_cell.coord.y + 1)
			for from_row in from_row_range: to_row_range.append(from_row - 1)
			continue
		Vector2i.UP:
			from_row_range = range(from_cell.coord.y - 1, to_cell.coord.y - 1, -1)
			for from_row in from_row_range: to_row_range.append(from_row + 1)
			continue
		Vector2i.DOWN, Vector2i.UP:
			for i in from_row_range.size():
				from_col_range.append(from_cell.coord.x)
				to_col_range.append(from_cell.coord.x)

	var batch_move_event := CompositeAnimationEvent.new()
	var empty_cell: Cell = null
	var coord_to_cell := _game_manager.coord_to_cell
	
	for i in from_col_range.size():
		var cell_from: Cell = coord_to_cell[Vector2i(from_col_range[i], from_row_range[i])]
		var cell_to: Cell = coord_to_cell[Vector2i(to_col_range[i], to_row_range[i])]
		empty_cell = _move_gem(cell_from, cell_to, batch_move_event)

	if empty_cell != null:
		empty_cell.gem = moved_gem
		batch_move_event.add(MoveAnimationEvent.new(moved_gem, empty_cell))
	
	_game_manager.animation_event_queue.push_front(batch_move_event)


func _move_gem(from_cell: Cell, to_cell: Cell, batch_move_event: CompositeAnimationEvent) -> Cell:
	print("Move from %s to %s" % [from_cell.coord, to_cell.coord])
	batch_move_event.add(MoveAnimationEvent.new(from_cell.gem, to_cell))
	to_cell.gem = from_cell.gem
	from_cell.gem = null
	return from_cell

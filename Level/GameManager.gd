class_name GameManager
extends Node

signal move_gem(from: Gem, to: Gem)

@export var max_seleciton: int = 2

var selected_cells: Array[Cell]

var coord_to_cell: Dictionary = {}
var cell_to_coord: Dictionary = {}

var gem_to_cell: Dictionary = {}
var cell_to_gem: Dictionary = {}

var turn_playing: bool = false

var animation_event_queue: Array[AnimationEvent]
var animation_playing: bool = false
var game_event_queue: Array[GameEvent]

func _process(delta):
	if not animation_playing and animation_event_queue.size() > 0:
		animation_playing = true
		var event_move: AnimationEvent = animation_event_queue.pop_back()
		await event_move.play()
		animation_playing = false

func register_cell(cell: Cell, coord: Vector2i) -> void:
	coord_to_cell[coord] = cell
	cell_to_coord[cell] = coord

func register_gem(gem: Gem, coord: Vector2i) -> void:
	var cell: Cell = coord_to_cell[coord]
	gem_to_cell[gem] = cell
	cell_to_gem[cell] = gem

func select_cell(cell: Cell) -> void:
	if turn_playing: return

	var selected_index: int = selected_cells.find(cell)
	var not_found = selected_index < 0
	if  not_found && selected_cells.size() < max_seleciton:
		selected_cells.append(cell)
		if (selected_cells.size() == max_seleciton):
			_play_turn()
		else:
			cell.selected = true
	else:
		selected_cells.remove_at(selected_index)
		cell.selected = false

func _play_turn() -> void:
	turn_playing = true
	
	var from: Cell = selected_cells[0]
	var to: Cell = selected_cells[1]
	
	for selected_cell in selected_cells:
		selected_cell.selected = false
	selected_cells.clear()
	
	var batch_move_event: CompositeAnimationEvent = CompositeAnimationEvent.new()
	
	print("Moving from %s to %s" % [from.coord, to.coord])
	batch_move_event.add(MoveAnimationEvent.new(cell_to_gem[from], to))

	if from.coord.x == to.coord.x: # Same column	
		var from_row: int
		var to_row: int
		var from_offset: int
		var to_offset: int
		if from.coord.y > to.coord.y:
			from_row = to.coord.y
			to_row = from.coord.y
			from_offset = 0
			to_offset = 1
		else:
			from_row = from.coord.y
			to_row = to.coord.y
			from_offset = 1
			to_offset = 0
		for row in range(from_row, to_row):
			var from_cell: Cell = coord_to_cell[Vector2i(from.coord.x, row + from_offset)]
			var to_cell: Cell = coord_to_cell[Vector2i(from.coord.x, row + to_offset)]
			print("Moving from %s to %s" % [from_cell.coord, to_cell.coord])
			batch_move_event.add(MoveAnimationEvent.new(cell_to_gem[from_cell], to_cell))
	if from.coord.y == to.coord.y: # Same row
		var from_col: int
		var to_col: int
		var from_offset: int
		var to_offset: int
		if from.coord.x > to.coord.x:
			from_col = to.coord.x
			to_col = from.coord.x
			from_offset = 0
			to_offset = 1
		else:
			from_col = from.coord.x
			to_col = to.coord.x
			from_offset = 1
			to_offset = 0
		for col in range(from_col, to_col):
			var from_cell: Cell = coord_to_cell[Vector2i(col + from_offset, from.coord.y)]
			var to_cell: Cell = coord_to_cell[Vector2i(col + to_offset, from.coord.y)]
			print("Moving from %s to %s" % [from_cell.coord, to_cell.coord])
			batch_move_event.add(MoveAnimationEvent.new(cell_to_gem[from_cell], to_cell))
	
	animation_event_queue.push_front(batch_move_event)
	turn_playing = false

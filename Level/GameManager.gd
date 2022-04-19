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

func register_cell(cell: Cell, col: int, row: int) -> void:
	coord_to_cell[[col, row]] = cell
	cell_to_coord[cell] = [col, row]

func register_gem(gem: Gem, col: int, row: int) -> void:
	var cell: Cell = coord_to_cell[[col, row]]
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
	animation_event_queue.push_front(batch_move_event)
	batch_move_event.add(MoveAnimationEvent.new(from.gem, to.gem))

	if from.col == to.col: # Same column	
		var from_row: int
		var to_row: int
		var from_offset: int
		var to_offset: int
		if from.row > to.row:
			from_row = to.row
			to_row = from.row
			from_offset = 0
			to_offset = 1
		else:
			from_row = from.row
			to_row = to.row
			from_offset = 1
			to_offset = 0
		for row in range(from_row, to_row):
			var from_cell: Cell = coord_to_cell[[from.col, row + from_offset]]
			var to_cell: Cell = coord_to_cell[[from.col, row + to_offset]]
			batch_move_event.add(MoveAnimationEvent.new(from_cell.gem, to_cell.gem))
	if from.row == to.row: # Same row
		var from_col: int
		var to_col: int
		var from_offset: int
		var to_offset: int
		if from.col > to.col:
			from_col = to.col
			to_col = from.col
			from_offset = 0
			to_offset = 1
		else:
			from_col = from.col
			to_col = to.col
			from_offset = 1
			to_offset = 0
		for col in range(from_col, to_col):
			var from_cell: Cell = coord_to_cell[[col + from_offset, from.row]]
			var to_cell: Cell = coord_to_cell[[col + to_offset, from.row]]
			batch_move_event.add(MoveAnimationEvent.new(from_cell.gem, to_cell.gem))
	
	turn_playing = false

class_name GameManager
extends Node

signal move_gem(from: Gem, to: Gem)

@export var animation_duration: float = 0.5
@export var max_seleciton: int = 2

var selected_cells: Array[Cell]

var coord_to_gem: Dictionary = {}
var gem_to_coord: Dictionary = {}

var coord_to_cell: Dictionary = {}
var cell_to_coord: Dictionary = {}

var gem_to_cell: Dictionary = {}
var cell_to_gem: Dictionary = {}

var turn_playing: bool = false
	
func _on_game_manager_move_gem(from: Gem, to: Gem):
	var tween := create_tween()
	tween.tween_property(from, "position", to.position, animation_duration).set_trans(Tween.TRANS_BACK)
	await tween.finished

func register_cell(cell: Cell, col: int, row: int) -> void:
	coord_to_cell[[col, row]] = cell
	cell_to_coord[cell] = [col, row]

func register_gem(gem: Gem, col: int, row: int) -> void:
	coord_to_gem[[col, row]] = gem
	gem_to_coord[gem] = [col, row]
	var cell: Cell = coord_to_cell[[col, row]]
	gem_to_cell[gem] = cell
	cell_to_gem[cell] = gem

func select_cell(cell: Cell) -> bool:
	if turn_playing: return false
	
	var selected_index: int = selected_cells.find(cell)
	var not_found = selected_index < 0
	if  not_found && selected_cells.size() < max_seleciton:
		selected_cells.append(cell)
		if (selected_cells.size() == max_seleciton):
			_play_turn()
			return false
		return true
	else:
		selected_cells.remove_at(selected_index)
		return false

func _play_turn() -> void:
	turn_playing = true
	
	var from: Cell = selected_cells[0]
	var to: Cell = selected_cells[1]
	
	for selected_cell in selected_cells:
		selected_cell.selected = false
	selected_cells.clear() 
	
	move_gem.emit(from.gem, to.gem)

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
			var from_gem: Gem = coord_to_gem[[from.col, row + from_offset]]
			var to_gem: Gem = coord_to_gem[[from.col, row + to_offset]]
			move_gem.emit(from_gem, to_gem)
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
			var from_gem: Gem = coord_to_gem[[col + from_offset, from.row]]
			var to_gem: Gem = coord_to_gem[[col + to_offset, from.row]]
			move_gem.emit(from_gem, to_gem)
	
	turn_playing = false

class_name GameManager
extends Node

@export var gem_scene: PackedScene
@export var cell_scene: PackedScene
@export var board_size: Vector2i
@export var cell_size: int
@export var max_seleciton: int = 2

var selected_cells: Array[Cell]
var coord_to_cell: Dictionary = {}
var game_event_queue: Array[GameEvent]
var animation_event_queue: Array[AnimationEvent]

var _turn_playing: bool = false
var _animation_playing: bool = false

@onready var camera_2d := $Camera2D
@onready var gem_parent := $GemParent
@onready var cell_parent := $CellParent


func _ready():
	var view_rect_size := camera_2d.get_viewport().get_visible_rect().size

	var horizontal_margin: int = (view_rect_size.x - (cell_size * board_size.x)) / 2
	var vertical_margin: int = (view_rect_size.y - (cell_size * board_size.y)) / 2
	
	for row in range(0, board_size.y):
		for col in range(0, board_size.x):
			var coord := Vector2i(col, row)
			
			var x_pos: int = horizontal_margin + col * cell_size
			var y_pos: int = vertical_margin + row * cell_size
			var pos := Vector2(x_pos, y_pos)
			
			var cell: Cell = _instantiate_cell(coord, pos)
			var gem: Gem = instantiate_gem(cell)
			gem.spawn()


func _process(delta):
	if not _animation_playing and animation_event_queue.size() > 0:
		_play_animation()
	elif (
		not _animation_playing
		and animation_event_queue.size() == 0
		and Input.is_action_just_pressed("end_turn")
	): 
		_play_turn()


func instantiate_gem(cell: Cell) -> Gem:
	var gem: Gem = gem_scene.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	cell.set_gem_in_cell_position(gem)
	gem_parent.add_child(gem)
	print("Instantiated cell at %s" % cell.coord)
	return gem


func select_cell(cell: Cell) -> void:
	if _turn_playing: return
	
	var selected_index: int = selected_cells.find(cell)
	var not_found = selected_index < 0
	
	if not_found:
		selected_cells.push_front(cell)
		cell.selected = true
	else:
		selected_cells.remove_at(selected_index)
		cell.selected = false


func _instantiate_cell(coord: Vector2i, pos: Vector2) -> Cell:
	var cell: Cell = cell_scene.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	cell_parent.add_child(cell)
	cell.initialize(self, coord, pos, cell_size)
	coord_to_cell[coord] = cell
	return cell


func _play_animation() -> void:
	_animation_playing = true
	var animation_event: AnimationEvent = animation_event_queue.pop_back()
	await animation_event.play_animation()
	_animation_playing = false


func _play_turn() -> void:
	while selected_cells.size() > 1:
		game_event_queue.push_front(MoveGameEvent.new(self))
		game_event_queue.push_front(ClearGameEvent.new(self))

		while game_event_queue.size() > 0:
			game_event_queue.pop_back().run_game_event()


func _on_play_turn_button_pressed(button_pressed):
	_play_turn()

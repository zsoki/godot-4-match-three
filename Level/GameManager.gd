class_name GameManager
extends Node

@export var max_seleciton: int = 2

var gem_parent: Node
var gem_scene: PackedScene
var board_size: Vector2i

var selected_cells: Array[Cell]
var coord_to_cell: Dictionary = {}

var turn_playing: bool = false
var animation_event_queue: Array[AnimationEvent]
var animation_playing: bool = false
var game_event_queue: Array[GameEvent]


func _process(delta):
	if not animation_playing and animation_event_queue.size() > 0:
		_play_animation()


func _play_animation() -> void:
	animation_playing = true
	var animation_event: AnimationEvent = animation_event_queue.pop_back()
	await animation_event.play()
	animation_playing = false


func set_board_size(board_size: Vector2i) -> void:
	self.board_size = board_size


func initialize_gem_builder(gem_parent: Node, gem_scene: PackedScene) -> void:
	self.gem_parent = gem_parent
	self.gem_scene = gem_scene


func instantiate_gem(cell: Cell) -> Gem:
	var gem: Gem = gem_scene.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	cell.set_gem(gem)
	gem_parent.add_child(gem)
	print("Instantiated cell at %s" % cell.coord)
	return gem


func register_cell(cell: Cell, coord: Vector2i) -> void:
	coord_to_cell[coord] = cell


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
	game_event_queue.push_front(MoveGameEvent.new(self))
	game_event_queue.push_front(ClearGameEvent.new(self))
	
	while game_event_queue.size() > 0:
		game_event_queue.pop_back().run()
	
	turn_playing = false

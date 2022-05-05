class_name Cell
extends Area2D


@export var cell_shape: RectangleShape2D

var coord: Vector2i
var gem: Gem:
	set = _set_gem
var selected: bool = false:
	set = _set_selected

var _game_manager: GameManager

@onready var debug_label: Label = $DebugLabel
@onready var arrow: Line2D = $Arrow


func _draw():
	var border_color := Color.RED if selected else Color.WHITE_SMOKE
	var border_thickness := 6 if selected else 2
	var border_vector := Vector2(border_thickness, border_thickness)

	var start_position := Vector2(-(cell_shape.size / 2) + border_vector)
	var width := cell_shape.size - border_vector * 2
	draw_rect(Rect2(start_position, width), border_color, false, border_thickness)


func initialize(game_manager: GameManager, coord: Vector2i, position: Vector2, cell_size: int):
	self.coord = coord
	self.position = position
	_game_manager = game_manager
	cell_shape.size = Vector2(cell_size, cell_size)
	if Global.debug:
		debug_label.visible = true
		debug_label.text = "%s" % coord
	else:
		debug_label.visible = false
	update()


func set_gem_in_cell_position(gem: Gem) -> void:
	self.gem = gem
	gem.position = position


func _set_gem(value: Gem) -> void:
	gem = value
	if Global.debug:
		arrow.attach_to_gem(gem)
	
	
func _set_selected(value: bool) -> void:
	selected = value
	update()
	print("%s cell has been %s" % [coord, "SELECTED" if value else "UNSELECTED"])


func _on_cell_input_event(viewport, event, shape_idx):
	if (event.is_action_pressed("select")):
		_game_manager.select_cell(self)

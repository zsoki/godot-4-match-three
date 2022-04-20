class_name Cell
extends Area2D

@export_node_path(Label) var _debug_label
@export var cell_shape: RectangleShape2D

var debug_label: Label
var coord: Vector2i
var game_manager: GameManager
var gem: Gem

var selected: bool = false:
	set(value):
		selected = value
		update()
		print("%s cell has been %s" % [coord, "SELECTED" if value else "UNSELECTED"])

func _draw():
	var border_color: Color = Color.RED if selected else Color.WHITE
	var border_thickness: int = 4 if selected else 2
	draw_rect(Rect2(Vector2(-(cell_shape.size / 2)), cell_shape.size), border_color, false, border_thickness)

func initialize(game_manager: GameManager, coord: Vector2i, position: Vector2, cell_size: int):
	self.game_manager = game_manager
	self.coord = coord
	self.position = position
	cell_shape.size = Vector2(cell_size, cell_size)
	debug_label = get_node(_debug_label)
	debug_label.text = "%s" % coord
	update()

func set_gem(gem: Gem):
	self.gem = gem
	gem.position = position

func _on_cell_input_event(viewport, event, shape_idx):
	if (event.is_action_pressed("select")):
		game_manager.select_cell(self)

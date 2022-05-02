extends Node

@export var gem_scene: PackedScene
@export var cell_scene: PackedScene
@export var cols: int
@export var rows: int
@export var cell_size: int

# Called when the node enters the scene tree for the first time.
func _ready():
	var view_rect_size: Vector2 = $Camera2D.get_viewport().get_visible_rect().size

	var horizontal_margin: int = (view_rect_size.x - (cell_size * cols)) / 2
	var vertical_margin: int = (view_rect_size.y - (cell_size * rows)) / 2
	
	$GameManager.set_board_size(Vector2i(cols, rows))
	$GameManager.initialize_gem_builder($GemParent, gem_scene)
	
	for row in range(0, rows):
		for col in range(0, cols):
			var x_pos: int = horizontal_margin + col * cell_size
			var y_pos: int = vertical_margin + row * cell_size
			
			var cell: Cell = cell_scene.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
			cell.initialize($GameManager, Vector2i(col, row), Vector2(x_pos, y_pos), cell_size)
			$CellParent.add_child(cell)
			$GameManager.register_cell(cell, Vector2i(col, row))
			
			var gem: Gem = $GameManager.instantiate_gem(cell)
			gem.spawn()

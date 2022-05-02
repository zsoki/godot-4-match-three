class_name DropGameEvent extends GameEvent

var game_manager: GameManager
var board_size: Vector2i
var coord_to_cell: Dictionary
var game_event_queue: Array[GameEvent]
var animation_event_queue: Array[AnimationEvent]

func _init(game_manager: GameManager):
	self.game_manager = game_manager
	board_size = game_manager.board_size
	coord_to_cell = game_manager.coord_to_cell
	game_event_queue = game_manager.game_event_queue
	animation_event_queue = game_manager.animation_event_queue


func run() -> void:
	var drop_animation_event := CompositeAnimationEvent.new()
	
	for col in board_size.x:
		for row in range(board_size.y - 1, -1, -1):
			var coord := Vector2i(col, row)
			var empty_cell: Cell = coord_to_cell[coord]
			
			if empty_cell.gem == null:
				var replace_row := row
				
				while not replace_row <= 0:
					replace_row -= 1
					var replace_coord := Vector2i(col, replace_row)
					var replace_cell: Cell = coord_to_cell[replace_coord]
					if replace_cell.gem == null:
						continue
					
					empty_cell.gem = replace_cell.gem
					replace_cell.gem = null
					drop_animation_event.add(MoveAnimationEvent.new(empty_cell.gem, empty_cell))
					break
	
	animation_event_queue.push_front(drop_animation_event)
	game_event_queue.push_front(SpawnGameEvent.new(game_manager))

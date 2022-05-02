class_name SpawnGameEvent extends GameEvent

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
	var composite_animation_event := CompositeAnimationEvent.new()
	
	for col in board_size.x:
		for row in board_size.y:
			var coord := Vector2i(col, row)
			var cell: Cell = coord_to_cell[coord]
			if cell.gem == null:
				var gem: Gem = game_manager.instantiate_gem(cell)
				composite_animation_event.add(SpawnAnimationEvent.new(gem))
	
	animation_event_queue.push_front(composite_animation_event)
	game_event_queue.push_front(ClearGameEvent.new(game_manager))
	

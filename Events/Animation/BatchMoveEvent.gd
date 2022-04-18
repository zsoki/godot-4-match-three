class_name BatchMoveEvent extends AnimationEvent

var move_events: Array[MoveEvent]

func add(from: Gem, to: Gem) -> void:
	move_events.append(MoveEvent.new(from, to))

func play() -> void:
	for move in move_events:
		move.play()
	move_events.clear()

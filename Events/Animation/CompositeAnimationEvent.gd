class_name CompositeAnimationEvent extends AnimationEvent

var animation_events: Array[AnimationEvent]

func add(animation_event: AnimationEvent) -> void:
	animation_events.append(animation_event)
	
func add_all(animation_events: Array[AnimationEvent]) -> void:
	self.animation_events = animation_events

func play() -> void:
	for animation_event in animation_events:
		animation_event.play()
	animation_events.clear()

class_name CompositeAnimationEvent
extends AnimationEvent


var _animation_events: Array[AnimationEvent]


func play_animation() -> void:
	for animation_event in _animation_events:
		animation_event.play_animation()

#	TODO hack for waiting for the animations
	await Engine.get_main_loop().create_timer(.35).timeout
	_animation_events.clear()


func add(animation_event: AnimationEvent) -> void:
	_animation_events.append(animation_event)

	
func add_all(animation_events: Array[AnimationEvent]) -> void:
	_animation_events = animation_events

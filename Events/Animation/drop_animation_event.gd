class_name DropAnimationEvent
extends AnimationEvent


const ANIMATION_DURATION: float = 0.4

var _gem: Gem = null
var _cell: Cell = null


func _init(gem: Gem, cell: Cell):
	_gem = gem
	_cell = cell


func play_animation() -> void:
	var tween := _gem.get_tree().create_tween().bind_node(_gem)
	tween.tween_property(_gem, "position", _cell.position, ANIMATION_DURATION).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	await tween.finished

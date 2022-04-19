class_name MoveAnimationEvent extends AnimationEvent

var from: Gem = null
var to: Gem = null
var animation_duration: float = 0.5

func _init(from: Gem, to: Gem):
	super()
	self.from = from
	self.to = to

func play():
	var tween := from.get_tree().create_tween().bind_node(from)
	tween.tween_property(from, "position", to.position, animation_duration).set_trans(Tween.TRANS_BACK)
	await tween.finished

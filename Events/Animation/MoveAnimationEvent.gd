class_name MoveAnimationEvent extends AnimationEvent

var gem: Gem = null
var cell: Cell = null
var animation_duration: float = 0.5

func _init(gem: Gem, cell: Cell):
	super()
	self.gem = gem
	self.cell = cell

func play() -> void:
	var tween := gem.get_tree().create_tween().bind_node(gem)
	tween.tween_property(gem, "position", cell.position, animation_duration).set_trans(Tween.TRANS_BACK)
	await tween.finished

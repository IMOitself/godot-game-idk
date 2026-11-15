extends Area2D

@export var camera: Camera2D
var tween: Tween

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "player":
		_move_offset(-100)

func _on_body_exited(body):
	if body.name == "player":
		_move_offset(0.0)

func _move_offset(target: float):
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(camera, "offset:x", target, 0.8)

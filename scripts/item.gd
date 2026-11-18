extends RigidBody2D

@onready var rigidbody_collision: CollisionShape2D = $rigidbody_collision

var isPickedUp := false
var canPickUp := false
var animationTime = 0.2

func _ready() -> void:
	for c in get_children():
		c.scale *= scale
		c.position *= scale
	scale = Vector2.ONE
	set_deferred("freeze", true)
	rigidbody_collision.set_deferred("disabled", true)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == get_tree().get_first_node_in_group("player"):
		if not isPickedUp: canPickUp = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == get_tree().get_first_node_in_group("player"):
		canPickUp = false

func _input(event: InputEvent) -> void:
	var player = get_tree().get_first_node_in_group("player")
	var isPlayerParent = get_parent() == player

	if canPickUp and player.pickupped_item == null and event.is_action_pressed("interact"):
		freeze = true
		rigidbody_collision.disabled = true
		rotation = 0
		player.pickupped_item = self
		_pickup_animation()
		isPickedUp = true
		canPickUp = false

	if isPickedUp and isPlayerParent and event.is_action_pressed("interact"):
		player.pickupped_item = null
		isPickedUp = false
		canPickUp = true
		add_collision_exception_with(player)
		reparent(get_tree().current_scene)
		scale = Vector2.ONE
		freeze = false
		rigidbody_collision.disabled = false
		var xForce = player.get_direction() * 500
		apply_impulse(Vector2(xForce, 800))

func _pickup_animation():
	var player = get_tree().get_first_node_in_group("player")
	player.pick_up(animationTime)
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", player.global_position + Vector2(0, -300), animationTime)
	await tween.finished
	
	reparent(player)

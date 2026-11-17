extends Area2D

const ITEM = preload("uid://d033d4poyb1a")
const SPAWN_Y = 400

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "player":
		for i in range(10):
			spawn_item()

func _on_body_exited(body):
	if body.name == "player":
		clear_all_items()

func spawn_item():
	var half_width = collision_shape.shape.size.x / 2
	var x = randf_range(-half_width, half_width)
	
	var item = ITEM.instantiate()
	item.position = collision_shape.position + Vector2(x, SPAWN_Y)
	item.add_to_group("items")
	add_child(item)

func clear_all_items():
	for child in get_children():
		if child.is_in_group("items"):
			child.queue_free()

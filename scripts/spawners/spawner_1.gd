extends Area2D

const ITEM = preload("uid://duayalk25sbkd")
const SPAWN_Y = 400

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready():
	body_entered.connect(_on_spawner_entered)
	body_exited.connect(_on_spawner_exited)

func _on_spawner_entered(body):
	if body.name == "player":
		for i in range(10):
			spawn_item()

func _on_spawner_exited(body):
	if body.name == "player":
		clear_all_items()

func spawn_item():
	var half_width = collision_shape.shape.size.x / 2
	var x = randf_range(-half_width + 1200, half_width - 300)
	
	var item = ITEM.instantiate()
	item.add_to_group("items")
	item.scale = Vector2(0.3, 0.3)
	item.position = collision_shape.position + Vector2(x, SPAWN_Y)
	add_child(item)

func clear_all_items():
	for child in get_children(): if child.is_in_group("items"): child.queue_free()

extends Area2D

const ITEM = preload("uid://d033d4poyb1a")
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
	var x = randf_range(-half_width, half_width)
	
	var item = ITEM.instantiate()
	item.position = collision_shape.position + Vector2(x, SPAWN_Y)
	item.add_to_group("items")
	var player = get_tree().current_scene.get_node("player")
	item.entered.connect(player._on_item_entered)
	item.exited.connect(player._on_item_exited)
	add_child(item)

func clear_all_items():
	for child in get_children(): if child.is_in_group("items"): child.queue_free()

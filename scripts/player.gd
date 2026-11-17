extends CharacterBody2D

const SPEED = 800.0
const JUMP_VELOCITY = -200
var selected_item = null
var pickupped_item = null

@onready var last_pickupped_item: Area2D = $last_pickupped_item

# ============================================================
#
# INTERACTION LOGIC
#
# ============================================================

func interact():
	# PICKUP ITEM
	if selected_item == null: return
	if pickupped_item != null: return
	
	for child in last_pickupped_item.get_children():
		child.queue_free()

	var item_copy = selected_item.duplicate()
	item_copy.position = Vector2.ZERO
	last_pickupped_item.add_child(item_copy)
	pickupped_item = item_copy

	selected_item.queue_free()
	selected_item = null

# ============================================================
#
# SELECTABLE ITEMS LOGIC
#
# ============================================================

func _on_item_entered(item):
	# old
	if selected_item and selected_item != item:
		selected_item.scale = Vector2(1, 1)
	
	selected_item = item
	selected_item.scale = Vector2(1.1, 1.1)

func _on_item_exited(item):
	if selected_item == item:
		selected_item.scale = Vector2(1, 1)
		selected_item = null

# ============================================================
#
# ANIMATIONS AND INPUTS LOGIC
#
# ============================================================

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
var is_interacting: bool = false

func _physics_process(delta: float) -> void:
	if not is_on_floor(): velocity += get_gravity() * delta
	
	handle_anims()
	
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction == -1: anim.flip_h = true
	elif direction == 1: anim.flip_h = false
	
	if direction:
		velocity.x = direction * SPEED
		if(is_on_floor()): velocity.y = JUMP_VELOCITY # auto hop
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if pickupped_item: $count.text = str(1)
	else: $count.text = ""

	move_and_slide()

func handle_anims():
	if Input.is_action_just_pressed("interact") and not is_interacting:
		is_interacting = true
		anim.play("interact")
		await anim.animation_finished
		is_interacting = false
		interact()

	if not is_interacting: anim.play("idle")
	
func _on_animation_finished():
	if anim.animation == "interact":
		is_interacting = false

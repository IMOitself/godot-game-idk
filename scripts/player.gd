extends CharacterBody2D


const SPEED = 800.0
const JUMP_VELOCITY = -200

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
var is_attacking: bool = false

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

	move_and_slide()

func handle_anims():
	if Input.is_action_just_pressed("attack") and not is_attacking:
		is_attacking = true
		anim.play("attack")
		await anim.animation_finished
		is_attacking = false
		
	if is_attacking:
		return
	
	anim.play("idle")
	
func _on_animation_finished():
	if anim.animation == "attack":
		is_attacking = false

# SELECTABLE ITEMS LOGIC

var selected_item = null

func _on_item_entered(item):
	# old
	if selected_item and selected_item != item: selected_item.scale = Vector2(1, 1)
	
	selected_item = item
	selected_item.scale = Vector2(1.1, 1.1)

func _on_item_exited(item):
	if selected_item == item:
		selected_item.scale = Vector2(1, 1)
		selected_item = null

# =========================
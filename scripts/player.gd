extends CharacterBody2D

const SPEED = 800.0
const JUMP_VELOCITY = -200
var pickupped_item = null
var is_interacting: bool = false

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

# ============================================================
#
# INTERACTION LOGIC
#
# ============================================================

func pick_up(duration):
	set_physics_process(false)
	
	anim.play("interact")
	
	await get_tree().create_timer(duration).timeout
	
	set_physics_process(true)

func get_direction():
	if anim.flip_h: return -1
	else: return 1

# ============================================================
#
# ANIMATIONS AND INPUTS LOGIC
#
# ============================================================

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
	if Input.is_action_just_pressed("interact") and not is_interacting:
		is_interacting = true
		anim.play("interact")
		await anim.animation_finished
		is_interacting = false

	if not is_interacting: anim.play("idle")
	
func _on_animation_finished():
	if anim.animation == "interact":
		is_interacting = false

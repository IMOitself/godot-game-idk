extends CharacterBody2D


const SPEED = 800.0
const JUMP_VELOCITY = -300

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
var is_attacking: bool = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	handle_anims()
	
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction == -1:
		anim.flip_h = true
	elif direction == 1:
		anim.flip_h = false
	
	if direction:
		velocity.x = direction * SPEED
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
	
	#if not is_on_floor():
		#anim.play("jump")
	#else:
		#anim.play("idle")
	
func _on_animation_finished():
	if anim.animation == "attack":
		is_attacking = false

extends CharacterBody2D

const SPEED := 100
const HIT_COOLDOWN := 1.0   # segundos de espera entre hits

var current_dir := "none"
var hit_timer := 0.0

func _physics_process(delta):
	# — atualiza cooldown
	if hit_timer > 0.0:
		hit_timer = max(hit_timer - delta, 0.0)

	# — se estiver atacando, não se move
	var anim = $AnimatedSprite2D
	if anim.animation == "hit" and anim.is_playing():
		velocity = Vector2.ZERO
		move_and_slide()
		return

	# — movimento
	var input_vec := Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		current_dir = "right";  input_vec.x += 1
	if Input.is_action_pressed("ui_left"):
		current_dir = "left";   input_vec.x -= 1
	if Input.is_action_pressed("ui_down"):
		current_dir = "down";   input_vec.y += 1
	if Input.is_action_pressed("ui_up"):
		current_dir = "up";     input_vec.y -= 1

	if input_vec != Vector2.ZERO:
		input_vec = input_vec.normalized()
		velocity = input_vec * SPEED
	else:
		velocity = Vector2.ZERO

	move_and_slide()
	

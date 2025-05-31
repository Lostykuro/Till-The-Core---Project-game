extends CharacterBody2D

var SPEED := 100
var current_dir := "down"  # direção padrão ao iniciar
var current_action:= "none"
var is_moving := false
var on_action := false

var hit_cooldown := 0.5  # em segundos
var time_since_last_hit := 0.0
var use_cooldown := 0.1  # em segundos
var time_since_last_use := 0.0

var shadow_pos := Vector2.ZERO
var shadow_lerp_speed := 24

@onready var sprite := $AnimatedSprite2D
@onready var hitbox_front := $Hitbox/Front_hitbox
@onready var hitbox_back := $Hitbox/Back_hitbox
@onready var shadow = $shadow
@export var sfx_hit :AudioStream
@export var sfx_footsteps :AudioStream
@export var sfx_use :AudioStream

var footstep_frames: Array = [1,3]
var hit_frames: Array = [6]
signal health_changed(current_hp)
@export var MaxHp= 20
@onready var hitPoints= MaxHp


var already_hit_targets := []

func _ready():
	hitPoints = Global.hitPoints
	MaxHp = Global.MaxHp
	shadow_pos = global_position 
	shadow.global_position = shadow_pos
	sprite.animation_finished.connect(_on_AnimatedSprite2D_animation_finished)


func _physics_process(delta):
	time_since_last_hit += delta
	time_since_last_use += delta
	var input_vec := Vector2.ZERO
	is_moving = false
	if !on_action:
		if Input.is_action_pressed("Move_right"):
			current_dir = "right";  input_vec.x += 1
		if Input.is_action_pressed("Move_left"):
			current_dir = "left";   input_vec.x -= 1
		if Input.is_action_pressed("Move_down"):
			current_dir = "down";   input_vec.y += 1
		if Input.is_action_pressed("Move_up"):
			current_dir = "up";     input_vec.y -= 1
		if Input.is_action_pressed("Run"):
			SPEED=170
		else :
			SPEED=100
 
	if Input.is_action_pressed("Hit") and not on_action and time_since_last_hit >= hit_cooldown:
		on_action = true
		current_action = "hit"

	if Input.is_action_pressed("Use") and not on_action and time_since_last_use>=use_cooldown:
		on_action = true; current_action="use"
		recieve_damage(1)
	
	
	if input_vec != Vector2.ZERO:
		is_moving = true
		input_vec = input_vec.normalized()
		velocity = input_vec * SPEED
	else:
		velocity = Vector2.ZERO

	shadowLerp(delta)
	move_and_slide()
	play_animation()

func play_animation():
	if is_moving:
		if current_dir == "right":
			sprite.flip_h = false
			sprite.play("walk_side")
		elif current_dir == "left":
			sprite.flip_h = true
			sprite.play("walk_side")
		elif current_dir == "up":
			sprite.flip_h = false
			sprite.play("walk_back")
		elif current_dir =="down":
			sprite.flip_h = false
			sprite.play("walk_front")

	elif !is_moving and !on_action:
		if current_dir == "down" or current_dir == "left" or current_dir == "right":
			sprite.play("Idle_front")
		elif current_dir == "up":
			sprite.play("Idle_back")
			
	elif on_action:
		if current_action== "hit" and (current_dir == "down" or current_dir == "left" or current_dir == "right"):
			sprite.play("hit_front") 
		elif current_action== "hit" and current_dir == "up":
			sprite.play("hit_back")
		elif current_action=="use":
			current_dir=="down"
			sprite.play("use")
		
			
func _on_AnimatedSprite2D_animation_finished():
	if on_action:
		if current_action== "hit":
			print("just hitted")
			time_since_last_hit = 0.0 
			apply_hit()
			on_action = false
			current_action = "none"
		if current_action== "use":
			print("just used")
			time_since_last_use=0.0
			on_action = false
			current_action = "none"
		else:
			on_action=false
			current_action = "none"


func apply_hit():
	var hitbox = hitbox_back if current_dir == "up" else hitbox_front
	var bodies = hitbox.get_overlapping_bodies()
	
	for body in bodies:
		if body is Node2D and body.has_method("take_damage"):
			if body in already_hit_targets:
				continue  # já atingido nesse hit
				print("Atingido:", body.name)
			body.take_damage(1)
			already_hit_targets.append(body)

	# Limpa a lista pra próxima vez
	already_hit_targets.clear()


func shadowLerp(delta):
	var target_pos = global_position + Vector2(0, 4)  # offset shadow below
	shadow_pos = shadow_pos.lerp(target_pos, delta * shadow_lerp_speed)
	shadow.global_position = shadow_pos
	
func recieve_damage(damage):
	if hitPoints == 0:
		print("player life:", hitPoints, "/", MaxHp)
		return
	elif hitPoints - damage <= 0:
		hitPoints = 0
		Global.hitPoints = hitPoints
		print("player received -", damage, "hp of damage")
		print("player life:", hitPoints, "/", MaxHp)
		health_changed.emit(hitPoints)
		return

	hitPoints -= damage
	Global.hitPoints = hitPoints
	print("player received -", damage, "hp of damage")
	print("player life:", hitPoints, "/", MaxHp)
	health_changed.emit(hitPoints)


func load_sfx(sfx_to_load):
	if $sfx_player.stream != sfx_to_load:
		$sfx_player.stop()
		$sfx_player.stream = sfx_to_load
	


func _on_animated_sprite_2d_frame_changed() -> void:
	if $AnimatedSprite2D.animation == "Idle":
		return

	# Hit sound on frame 6
	if current_action == "hit" and $AnimatedSprite2D.animation in ["hit_front", "hit_back"] and $AnimatedSprite2D.frame == 6:
		load_sfx(sfx_hit)
		$sfx_player.play()

	# Footstep sound

	if is_moving and $AnimatedSprite2D.frame in footstep_frames:
		load_sfx(sfx_footsteps)
		$sfx_player.play()

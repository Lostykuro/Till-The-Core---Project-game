extends Node2D

@export var drop_scene: PackedScene

@export_range(0, 100) var Initial_hit_points: int = 4
@export_range(0, 100) var hit_points: int = 4
@export var is_destroyed: bool = false
@export_range(0, 3) var destruction_level: int = 0

@onready var sprite := $AnimatedSprite2D




func _ready():
	hit_points=Initial_hit_points
	if is_destroyed:
		hit_points=0
		$CollisionShape2D.disabled = true
		destruction_level=3
	update_sprite()

func set_destruction_level(value):
	if is_destroyed:
		return  # impede alterações
	destruction_level = clamp(value, 0, 3)
	update_sprite()
	
	if destruction_level == 3:
		is_destroyed = true
		$CollisionShape2D.disabled = true
		z_index = -1  # pedra atrás do player
		spawnar_drop()
		
func take_damage(amount: int):
	if is_destroyed:
		return
	hit_points -= amount
	print("Dano recebido:", amount, "| HP restante:", hit_points)
	if hit_points <= 0:
		set_destruction_level(3)
	elif hit_points <= (Initial_hit_points / 3):
		set_destruction_level(2)
	elif hit_points <= (Initial_hit_points / 2):
		set_destruction_level(1)

func update_sprite():
	match destruction_level:
		0:
			sprite.frame = 0  # estágio intacto
		1:
			sprite.frame = 1  # meio destruída
		2:
			sprite.frame = 2  # só o restinho
		3:
			sprite.frame = 3 # completamente destruída

func spawnar_drop():
	if drop_scene:
		var drop = drop_scene.instantiate()
		drop.global_position = global_position + Vector2(0, 10)
		get_parent().add_child(drop)

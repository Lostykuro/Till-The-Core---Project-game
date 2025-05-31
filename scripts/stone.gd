extends Node2D
@export_range(0, 100) var Initial_hit_points: int = 4
@export_range(0, 100) var hit_points: int = 4
@export var is_destroyed: bool = false
@export_range(0, 3) var destruction_level: int = 0
var player_inside := false
var player_reference = null

@onready var sprite := $AnimatedSprite2D

var ore_types = ["diamond", "iron", "gold", "bismuth", "ruby", "crystal", "none"] #tipos de minerio
var ore_probabilities = {
	"none": 30,
	"iron": 23,
	"gold": 13,
	"bismuth": 7,
	"ruby": 11,
	"crystal": 8,
	"diamond": 7
}
var selected_ore_type = "none" #minerio inicial

var DropOre = preload("res://scenes/DropOre.tscn")

func _ready():
	hit_points = Initial_hit_points
	if is_destroyed:
		hit_points = 0
		$CollisionShape2D.disabled = true
		destruction_level = 3
		z_index = -1
	
	selected_ore_type = pick_random_ore()
	update_sprite()
	$Y_sorter.connect("body_entered", Callable(self, "_on_Y_sorter_body_entered"))
	$Y_sorter.connect("body_exited", Callable(self, "_on_Y_sorter_body_exited"))

func _process(delta):
	if player_reference:
		if player_reference.global_position.y < global_position.y:
			z_index = 2  # pedra NA FRENTE do player
		else:
			z_index = 0  # pedra ATRÁS do player
			
func set_destruction_level(value):
	if is_destroyed:
		return  # impede alterações
	destruction_level = clamp(value, 0, 3)
	update_sprite()
	
	if destruction_level == 3:
		is_destroyed = true
		$CollisionShape2D.disabled = true
		z_index = -1  # pedra atrás do player
		drop_ore()
		
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


func pick_random_ore() -> String:
	var total_weight = 0
	for weight in ore_probabilities.values():
		total_weight += weight

	var rand = randi() % total_weight
	var current = 0

	for ore in ore_probabilities.keys():
		current += ore_probabilities[ore]
		if rand < current:
			return ore
	
	return "none"  # fallback


func drop_ore():
	if selected_ore_type == "none":
		return  # nada dropa

	var drop = DropOre.instantiate()
	drop.global_position = global_position + Vector2(0, 8)
	drop.oreType = selected_ore_type
	drop.match_type_sprite()
	get_parent().add_child(drop)
	
	
func _on_Y_sorter_body_entered(body):
	if body.name == "Player":
		player_inside = true
		player_reference = body

func _on_Y_sorter_body_exited(body):
	if body.name == "Player":
		player_inside = false
		player_reference = null

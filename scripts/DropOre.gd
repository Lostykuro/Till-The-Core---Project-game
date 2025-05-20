extends Node2D

@onready var sprite := get_node_or_null("Ores")

var oreType = ""

func _ready():
	match_type_sprite()

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") :
		#Adicionar ao inventário //To-Do
		self.queue_free()


func match_type_sprite():
	if sprite == null:
		push_error("Sprite 'Ores' não foi encontrado!")
		return
	
	match oreType:
		"diamond":
			sprite.frame = 0  
		"iron":
			sprite.frame = 1  
		"gold":
			sprite.frame = 2  
		"bismuth":
			sprite.frame = 3 
		"ruby":
			sprite.frame = 4
		"crystal":
			sprite.frame = 5

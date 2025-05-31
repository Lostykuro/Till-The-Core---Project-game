extends Node2D

@onready var sprite := get_node_or_null("Ores")
@onready var collect_sfx := $collect_sfx

var oreType = ""

func _ready():
	match_type_sprite()

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if collect_sfx and collect_sfx.stream:
			collect_sfx.play()
			await collect_sfx.finished  # Wait for the sound to end
		queue_free()  # Then remove the node

func match_type_sprite():
	if sprite == null:
		push_error("Sprite 'Ores' não foi encontrado!")
		return
	
	match oreType:
		"diamond": sprite.frame = 0
		"iron": sprite.frame = 1
		"gold": sprite.frame = 2
		"bismuth": sprite.frame = 3
		"ruby": sprite.frame = 4
		"crystal": sprite.frame = 5

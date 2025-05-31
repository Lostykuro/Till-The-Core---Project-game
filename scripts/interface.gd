extends CanvasLayer

@onready var heart_container = $Control/HBoxContainer
const HEART_SCENE = preload("res://scenes/HeartSprite.tscn")
var player: Node = null

func _ready():
	# Espera um pequeno tempo para garantir que a cena carregou
	await get_tree().process_frame
	player = get_tree().get_nodes_in_group("Player")[0]

	var max_hp = player.MaxHp

	for i in range(max_hp):
		var heart = HEART_SCENE.instantiate()
		heart_container.add_child(heart)

	player.health_changed.connect(update_hearts)
	update_hearts(player.hitPoints)


func update_hearts(current_hp):
	var max_hp = player.MaxHp

	for i in range(heart_container.get_child_count()):
		var heart = heart_container.get_child(i)

		var heart_position_ratio = float(i + 1) / max_hp
		var hp_ratio = float(current_hp) / max_hp
		var diff = heart_position_ratio - hp_ratio

		var frame_index = 0

		if diff <= 0.0:
			frame_index = 0
		elif diff <= 0.1:
			frame_index = 1
		elif diff <= 0.2:
			frame_index = 2
		elif diff <= 0.3:
			frame_index = 3
		elif diff <= 0.4:
			frame_index = 4
		elif diff <= 0.5:
			frame_index = 5
		elif diff <= 0.6:
			frame_index = 6
		elif diff <= 0.7:
			frame_index = 7
		elif diff <= 0.85:
			frame_index = 8
		elif diff < 1:
			frame_index = 9
		elif diff >= 1:
			frame_index = 10

		heart.frame = frame_index

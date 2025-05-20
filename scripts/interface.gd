extends CanvasLayer

@onready var heart_container = $Control/HBoxContainer
const HEART_SCENE = preload("res://scenes/HeartSprite.tscn") # caminho real

var max_hp := 9

func _ready():
	for i in range(max_hp):
		var heart = HEART_SCENE.instantiate()
		heart_container.add_child(heart)

	var player = get_node("/root/MainScene/Player")
	player.health_changed.connect(update_hearts)
	update_hearts(player.hitPoints)

func update_hearts(current_hp):
	for i in range(heart_container.get_child_count()):
		var heart = heart_container.get_child(i)
		var frame_index = clamp(i - current_hp, 0, 8)
		heart.frame = frame_index

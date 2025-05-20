extends CharacterBody2D

#export(String) var item_type = 'Ore'
var metadata = {}

func _on_hitbox_body_entered(body: Node2D) -> void:
	#Inventory.add_item(player, metadata)
	self.queue_free()

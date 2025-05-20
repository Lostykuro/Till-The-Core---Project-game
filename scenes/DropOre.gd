extends Node2D


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") :
		#Adicionar ao inventário //To-Do
		self.queue_free()

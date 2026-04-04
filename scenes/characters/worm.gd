class_name Worm
extends Area2D








func _on_attack_area_body_entered(body: Node2D) -> void:
	body.hit(1)

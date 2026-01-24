class_name Explosion
extends Area2D

var targets : Array

func setup(pos : Vector2):
	position = pos



func _on_body_entered(body: Node2D) -> void:
	targets.append(body)
	
func hurt_targets():
	for target in targets:
		if target:
			target.hit()

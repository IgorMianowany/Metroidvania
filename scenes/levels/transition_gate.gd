extends Area2D

var target_position : Marker2D
@export var target : Data.Level

func _on_body_entered(body: Node2D) -> void:
	body.freeze()
	TransistionLayer.transition(target, Data.current_level)

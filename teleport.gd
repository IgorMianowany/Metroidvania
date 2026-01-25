class_name Teleport
extends Node2D

@onready var to : Marker2D = $Marker2D

func teleport(player : Player):
	player.global_position = to.global_position


func _on_area_body_entered(body: Node2D) -> void:
	teleport(body)

class_name Bullet
extends Area2D

var direction : Vector2
var speed : int = 200

const OFFSET : float = 16

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	
func setup(pos : Vector2, dir : Vector2):
	position = pos + dir * OFFSET
	direction = dir


func _on_body_entered(body: Node2D) -> void:
	if 'health' in body:
		body.hit()
	queue_free()

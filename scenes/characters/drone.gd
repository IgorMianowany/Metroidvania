extends CharacterBody2D

var direction : Vector2
var speed : float = 50
var player : Player
var health : int = 3:
	set(value):
		health = value
		if health <= 0:
			explode.emit(position, 3)
			queue_free()
			
signal explode(pos : Vector2, damage : int)

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(_delta: float) -> void:
	if player:
		var dir = (player.position - position).normalized()
		velocity = dir * speed
		move_and_slide()


func _on_player_detection_body_entered(body: Node2D) -> void:
	player = body


func _on_player_detection_body_exited(_body: Node2D) -> void:
	player = null
	
func hit(damage : int):
	health -= damage
	var tween = create_tween()
	tween.tween_property(sprite.material, 'shader_parameter/Progress', .8, 0.15)
	tween.tween_property(sprite.material, 'shader_parameter/Progress', 0.0, 0.3)


func _on_collision_shape_body_entered(_body: Node2D) -> void:
	explode.emit(position, 3)
	queue_free()

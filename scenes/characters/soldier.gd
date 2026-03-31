extends CharacterBody2D


var speed = 3500
const JUMP_VELOCITY = -400.0

var direction : float = 1

@onready var ledge_marker : Area2D = $LedgeMarker
@onready var animation_player : AnimationPlayer = $AnimationPlayer


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity()
	if velocity.x != 0 and animation_player.current_animation == "idle":
		animation_player.play("run")
	
	if direction:
		velocity.x = direction * speed * delta
	else:
		velocity.x = move_toward(velocity.x, 0, speed) * delta

	move_and_slide()


func _on_ledge_marker_body_exited(body: Node2D) -> void:
	direction *= -1
	scale.x *= -1

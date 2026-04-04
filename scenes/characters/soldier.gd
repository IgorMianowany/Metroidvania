class_name Soldier
extends CharacterBody2D


var speed = 3500
var speed_mod = 1
var health = 5:
	set(value):
		health = value
		if health <= 0:
			spawn_point.defeated = true
var direction : Vector2 = Vector2(1.0,0.0)
var is_player_in_range : bool = false
var player : Player
var spawn_point : Marker2D
var position_offset : float = 5
var shoot_up : bool = false

@onready var ledge_marker : Area2D = $LedgeMarker
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var bullet_scene := preload("res://scenes/bullets/soldier_bullet.tscn")
@onready var bullet_spawn : Marker2D = $BulletSpawn
@onready var center : Marker2D = $Center
@onready var sprite : Sprite2D = $Sprite2D


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity()
	
	if animation_player.current_animation == "die":
		return
		
	if not is_player_in_range and velocity.x != 0 and animation_player.current_animation == "idle":
		animation_player.play("run")
	
	if is_player_in_range:
		var dir = position.direction_to(player.global_position).sign()
		direction = Vector2(dir.x, 0)
		transform.x.x = dir.x + ((scale.x - 1) * dir.x)
		#if not animation_player.current_animation.begins_with("shoot"):
		if shoot_up:
			animation_player.play("shoot_v")
		else:
			animation_player.play("shoot_h")
	
	if direction:
		velocity.x = direction.x * speed * delta * speed_mod
	else:
		velocity.x = move_toward(velocity.x, 0, speed) * delta

	move_and_slide()

func _on_ledge_marker_body_exited(_body: Node2D) -> void:

	direction *= -1
	scale.x *= -1


func _on_player_detection_body_entered(body: Node2D) -> void:
	player = body
	is_player_in_range = true
	speed_mod = 0


func _on_player_detection_body_exited(_body: Node2D) -> void:
	is_player_in_range = false
	player = null
	animation_player.play("idle")
	speed_mod = 1
	
func _shoot():
	var bullet : Bullet = bullet_scene.instantiate()
	add_child(bullet)
	bullet.direction = center.position.direction_to(bullet_spawn.position)
	bullet.position = bullet_spawn.position
	
func setup(spawner : Marker2D):
	position = spawner.global_position
	spawn_point = spawner

func _die():
	queue_free()
	
func hit(damage : int):
	health -= damage
	var tween = create_tween()
	tween.tween_property(sprite.material, 'shader_parameter/Progress', .8, 0.15)
	tween.tween_property(sprite.material, 'shader_parameter/Progress', 0.0, 0.3)
	if health <= 0:
		animation_player.play("die")
	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name.begins_with("shoot"):
		shoot_up = player.position.y < position.y + position_offset and abs(player.position.x - position.x) < 25

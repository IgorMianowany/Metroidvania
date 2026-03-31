extends Node2D

var bullet_scene := preload("res://scenes/bullets/bullet.tscn")
var explosion_scene := preload("res://scenes/bullets/explosion.tscn")

func _ready() -> void:
	for drone in get_tree().get_nodes_in_group('drones'):
		drone.connect('explode', create_explosion)

func _on_player_shoot(pos: Vector2, dir: Vector2, gun : Data.Gun, damage : float = 1) -> void:
	if gun != Data.Gun.SHOTGUN:
		var bullet : Bullet = bullet_scene.instantiate()
		bullet.connect('explode', create_explosion)
		$Bullets.add_child(bullet)
		bullet.setup(pos, dir, gun)
	else:
		for drone in get_tree().get_nodes_in_group("drones"):
			var aim_angle = rad_to_deg(dir.angle())
			var enemy_angle = rad_to_deg((drone.position - pos).angle())
			if abs(aim_angle - enemy_angle) < 90 and pos.distance_to(drone.position) < 100:
				drone.hit(damage)
	
func create_explosion(pos : Vector2, damage : int):
	var explosion = explosion_scene.instantiate()
	call_deferred('_add_explosion', explosion)
	explosion.setup(pos, damage)
	
func _add_explosion(explosion : Explosion):
	$Entities.add_child(explosion)
	

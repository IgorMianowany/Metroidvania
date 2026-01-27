class_name Bullet
extends Area2D

var direction : Vector2
var speed : int = 200
var damage : int = 1
var gun_type: Data.Gun

@onready var sprite : Sprite2D = $Sprite2D

signal explode(pos : Vector2, dmg : int)

const TEXTURE = {
	Data.Gun.SINGLE : preload("res://graphics/fire/default.png"),
	Data.Gun.SHOTGUN : preload("res://graphics/fire/default.png"),
	Data.Gun.ROCKET : preload("res://graphics/fire/large.png")
}
const OFFSET : float = 16

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	
func setup(pos : Vector2, dir : Vector2, gun : Data.Gun):
	position = pos + dir * OFFSET
	direction = dir
	gun_type = gun
	sprite.texture = TEXTURE[gun_type]


func _on_body_entered(body: Node2D) -> void:
	if 'hit' in body:
		body.hit(damage)
	if gun_type == Data.Gun.ROCKET:
		explode.emit(position, 5)
	queue_free()

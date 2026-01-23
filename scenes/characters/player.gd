extends CharacterBody2D

var direction_x : float
var gravity = 100

@export var speed : float = 120
@export var acelleration : float = 600
@export var friction : float = 800

@onready var legs_sprite : Sprite2D = $Sprites/LegSprite
@onready var torso_sprite : Sprite2D = $Sprites/TorsoSprite
@onready var animation_player : AnimationPlayer = $AnimationPlayer

const GUN_DIRECTIONS = {
	Vector2i(0,0):   0,
	Vector2i(1,0):   0,
	Vector2i(1,1):   1, 
	Vector2i(0,1):   2,
	Vector2i(-1,1):  3,
	Vector2i(-1,0):  4,
	Vector2i(-1,-1): 5,
	Vector2i(0,-1):  6,
	Vector2i(1,-1):  7,
}

func _physics_process(delta: float) -> void:
	get_input()
	move(delta)
	move_and_slide()
	
func _process(_delta: float) -> void:
	animate()
	
func get_input():
	direction_x = Input.get_axis("left", "right")
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -200
	
func _input(event: InputEvent) -> void:
	if event.is_action("exit"):
		get_tree().quit()
		
func animate():
	var animation : String
	
	# legs
	if velocity.x != 0:
		legs_sprite.flip_h = direction_x < 0
	if is_on_floor():
		animation = 'run' if direction_x else 'idle'
	else:
		animation = 'jump'
		
	# torso
	var raw_dir = get_local_mouse_position().normalized()
	var adjusted_dir = Vector2i(round(raw_dir.x), round(raw_dir.y))
	
	
	torso_sprite.frame = GUN_DIRECTIONS[adjusted_dir]
	
		
		
		
		
	animation_player.current_animation = animation
		
func move(delta : float):
	if direction_x:
		velocity.x = move_toward(velocity.x, direction_x * speed, acelleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
	#velocity.x = direction_x * speed
	if not is_on_floor():
		velocity.y += gravity * delta
		

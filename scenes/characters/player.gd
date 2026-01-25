class_name Player
extends CharacterBody2D

var direction_x : float
var gravity = 100
var health : int = 5:
	set(value):
		health = value
		ui.set_health(health)
var dash_duration : float = .5
var is_dashing : bool = false
var is_crouching : bool = false
var crouching_speed_modifier : float = .85
var coyote_jump : bool = true
var on_floor : bool = true

@export_category("Move")
@export var dash_speed : float = 400
@export var speed : float = 120
@export var acelleration : float = 600
@export var friction : float = 800
@export_category("Jump")
@export var jump_height: float = 75
@export var jump_time_to_peak: float = 0.5
@export var jump_time_to_descent: float = 0.4
@export var coyote_jump_time : float = .5

@onready var jump_velocity: float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_descent)) * -1.0
@onready var legs_sprite : Sprite2D = $Sprites/LegSprite
@onready var torso_sprite : Sprite2D = $Sprites/TorsoSprite
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var reload_timer : Timer = $Timer/ReloadTimer
@onready var ui : UI = $UI
@onready var crosshair : Crosshair = $Sprites/Crosshair
@onready var standing_collision_shape : CollisionShape2D = $StandingCollision
@onready var crouching_collision_shape : CollisionShape2D = $CrouchCollision

signal shoot(pos : Vector2, dir : Vector2)

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

func _ready() -> void:
	ui.set_health(health)
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _physics_process(delta: float) -> void:
	get_input()
	move(delta)
	on_floor = is_on_floor()
	move_and_slide()
	
func _process(_delta: float) -> void:
	if on_floor and not is_on_floor() and velocity.y >= 0:
		$Timer/CoyoteTimer.start()
		
	animate()
	update_crosshair()
	
func get_input():
	direction_x = Input.get_axis("left", "right")
	if Input.is_action_just_pressed("jump") and (is_on_floor() or $Timer/CoyoteTimer.time_left):
		velocity.y = jump_velocity
		$Timer/CoyoteTimer.stop()
	if Input.is_action_just_pressed("descend"):
		fall_gravity *= 2
	if Input.is_action_just_released("descend"):
		fall_gravity *= .5
	if Input.is_action_just_pressed("shoot") and not reload_timer.time_left:
		shoot.emit(position, get_local_mouse_position().normalized())
		reload_timer.start()
	if Input.is_action_just_pressed("dash") and not is_dashing and is_on_floor():
		dash()
	if Input.is_action_just_pressed("crouch"):
		toggle_crouch()
	
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
	
		
	if is_crouching:
		torso_sprite.position.y = -1
		animation_player.current_animation = "crouch"
	else:
		torso_sprite.position.y = -8
		
func move(delta : float):
	if direction_x:
		velocity.x = move_toward(velocity.x, direction_x * speed, acelleration * delta)
		if is_crouching:
			velocity.x = velocity.x * crouching_speed_modifier
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
	#velocity.x = direction_x * speed
	if not is_on_floor():
		velocity.y += get_custom_gravity() * delta
		
func get_custom_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity
	
func hit(damage : int):
	health -= damage
	
func dash():
	is_dashing = true
	var tween = create_tween()
	tween.tween_property(self, "velocity:x", velocity.x + direction_x * dash_speed, .3)
	tween.tween_callback(_dash_finish)
	await(get_tree().create_timer(1).timeout)
	is_dashing = false
	
func _dash_finish():
	velocity.x = move_toward(velocity.x, 0, 50)

func update_crosshair():
	crosshair.position = get_local_mouse_position()

func toggle_crouch():
	crouching_collision_shape.disabled = is_crouching
	is_crouching = false if is_crouching else true
	standing_collision_shape.disabled = is_crouching


func _on_coyote_timer_timeout() -> void:
	coyote_jump = false

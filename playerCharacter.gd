extends CharacterBody2D

@export var bullet: PackedScene

@onready var animation_sprite = $AnimatedSprite2D
@onready var spawn_point: Marker2D = $SpawnPoint

const SPEED = 400.0
const JUMP_VELOCITY = -450.0


var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	Move()
	Jump()
	Animation()
	Shoot()



func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		animation_sprite.animation = "jump"

func Animation() -> void:
	if is_on_floor():
		if velocity.x < 0:
			animation_sprite.flip_h = true
			animation_sprite.animation = "walk"
		elif velocity.x > 0:
			animation_sprite.flip_h = false
			animation_sprite.animation = "walk"
		elif velocity.x == 0:
			animation_sprite.animation = "idle"
	else:
		animation_sprite.flip_h = (velocity.x < 0)
		animation_sprite.animation = "jump"


func Input_Movement():
	# Handle movement.
	var direction: float = Input.get_axis("move_left", "move_right")
	return direction

func Move():
	var direction = Input_Movement()
	if direction:
		velocity.x = direction * SPEED
	else:
		# Decelerate when there's no input.
		velocity.x = move_toward(velocity.x, 0 , 16)
	move_and_slide()

func Jump():
	# Handle jumping.
	if Input.is_action_just_pressed("_jump") and is_on_floor():
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2(.95, 1.15), .25)
		velocity.y = JUMP_VELOCITY
		print("Jumping")
		if is_on_floor():
			tween.tween_property(self, "scale", Vector2(1.2, .8), .4)
			tween.tween_property(self, "scale", Vector2(1, 1), .1)

func Shoot():
	var shoot_direction = Input_Movement()

	if shoot_direction != 0 and Input.is_action_just_pressed("shoot"):
		var inst: bullet = bullet.instantiate()
		inst.direction = int(shoot_direction)
		owner.add_child(inst)
		inst.transform = spawn_point.get_global_transform()
		print("Bang!")


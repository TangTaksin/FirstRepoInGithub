extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animation_sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Apply gravity if not on the floor.
	if not is_on_floor():
		velocity.y += gravity * delta

	Movement()
	Jump()
	PlayerAnimation()

func PlayerAnimation() -> void:
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
		animation_sprite.flip_h = (velocity.x < 0)  # Flip sprite when moving
		animation_sprite.animation = "jump"


func Movement():
	# Handle movement.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		# Decelerate when there's no input.
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()


func Jump():
	# Handle jumping.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		print("Jumping")


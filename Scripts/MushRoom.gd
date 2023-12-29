extends CharacterBody2D

const SPEED = 25
var direction = 1
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	_apply_gravity(delta)
	_move()
	move_and_slide()

func _apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func _move():
	velocity.x = SPEED * direction
	if is_on_wall():
		direction*= -1
		position.x += 1 * direction #Evita que se quede atascado

func hit():
	queue_free()

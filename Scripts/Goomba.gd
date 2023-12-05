extends CharacterBody2D

const SPEED = 25
var direction = -1
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var dying = false

@onready var animatedSprite= $AnimatedSprite2D

func _physics_process(delta):
	_apply_gravity(delta)
	_move()	
	move_and_slide()

func _apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func _move():
	if !dying: velocity.x = SPEED * direction #Evita que se mueva mientras está muriendo
	if is_on_wall():
		direction*= -1
		position.x += 1 * direction #Evita que se quede atascado

func hit():
	_die()

func _die():
	dying = true;
	velocity.x = 0
	animatedSprite.play("die")

func _on_animated_sprite_2d_animation_finished():
	if animatedSprite.animation == "die": queue_free()

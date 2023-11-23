extends CharacterBody2D

const SPEED = 50
var direction = -1
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var died = false

@onready var animatedSprite= $AnimatedSprite2D

func _physics_process(delta):
	_apply_gravity(delta)
	_move()	
	move_and_slide()

func _apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func _move():
	if !died: velocity.x = SPEED * direction

func _on_hitbox_body_entered(body):
	direction*= -1

func hit():
	_die()

func _die():
	died = true;
	velocity.x = 0
	animatedSprite.play("die")

func _on_animated_sprite_2d_animation_finished():
	if animatedSprite.animation == "die": queue_free()

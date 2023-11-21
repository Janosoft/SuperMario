extends CharacterBody2D

const SPEED = 10
const MAXSPEED = 125
const JUMP_VELOCITY = 350.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 0
var currentSpeed = 1
var is_big = false
var is_ducking = false
@onready var animatedSprite = $AnimatedSprite2D

func _physics_process(delta):
	_apply_gravity(delta)
	_animate()
	_controls()	
	move_and_slide()
	
func _apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func _controls():
	if is_on_floor():
		# JUMP
		if Input.is_action_just_pressed("jump"): velocity.y = - JUMP_VELOCITY
		# JUMP
		## Solo se puede cambiar la velocidad desde el suelo
		if Input.is_action_pressed("run"): currentSpeed= 1.5
		else: currentSpeed= 1	
		
	# MOVE
	direction = Input.get_axis("move_left", "move_right")
	if direction: velocity.x =  max(velocity.x - SPEED, -MAXSPEED) * currentSpeed if direction<0 else min(velocity.x + SPEED, MAXSPEED) * currentSpeed
	else: velocity.x = lerp(velocity.x,0.0,0.2)
	# MOVE
	
	# DUCK
	is_ducking= Input.is_action_pressed("duck")
	
	if Input.is_action_just_pressed("ui_accept"):
		if is_big: shrink()
		else: grow()
	# DUCK

func _animate():
	if animatedSprite.is_playing() and animatedSprite.animation in ["convert_small", "convert_big", "convert_fire"]:
		pass
	else:
		if is_big:
			if is_ducking:
				animatedSprite.play("duck_big")
			else:
				if direction: animatedSprite.flip_h = direction<0
				if is_on_floor():
					if abs(velocity.x)< SPEED: animatedSprite.play("idle_big")
					else : animatedSprite.play("walk_big")
				else:
					if velocity.y <0: animatedSprite.play("jump_big")
					else:
						if direction: animatedSprite.play("walk_big")
						else: animatedSprite.play("idle_big")
		else:
			if direction: animatedSprite.flip_h = direction<0
			if is_on_floor():
				if abs(velocity.x)< SPEED: animatedSprite.play("idle_small")
				else : animatedSprite.play("walk_small")
			else:
				if velocity.y <0: animatedSprite.play("jump_small")
				else:
					if direction: animatedSprite.play("walk_small")
					else: animatedSprite.play("idle_small")

func grow():
	animatedSprite.play("convert_big")
	is_big= true
	$CollisionShape2D_big.disabled= false
	$CollisionShape2D_small.disabled= true
	$Hitbox/CollisionShape2D_small.disabled= true
	$Hitbox/CollisionShape2D_big.disabled= false

func shrink():
	animatedSprite.play("convert_small")
	velocity.y =0
	is_big= false
	$CollisionShape2D_small.disabled= false
	$CollisionShape2D_big.disabled= true
	$Hitbox/CollisionShape2D_big.disabled= true
	$Hitbox/CollisionShape2D_small.disabled= false	

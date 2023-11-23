extends CharacterBody2D

const SPEED = 10
const MAXSPEED = 125
const JUMP_VELOCITY = 350.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 0
var lastDirection = 0
var currentSpeed = 1
var is_big = false
var is_ducking = false
@onready var animatedSprite = $AnimatedSprite2D
@onready var small_fistLeft = $Hitbox/CollisionShape2D_small_fist_left
@onready var small_fistRight = $Hitbox/CollisionShape2D_small_fist_right
@onready var big_fistLeft = $Hitbox/CollisionShape2D_big_fist_left
@onready var big_fistRight = $Hitbox/CollisionShape2D_big_fist_right

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
	if direction: 
		lastDirection= direction
		velocity.x =  max(velocity.x - SPEED, -MAXSPEED) * currentSpeed if direction<0 else min(velocity.x + SPEED, MAXSPEED) * currentSpeed		
	else: velocity.x = lerp(velocity.x,0.0,0.2)
	# MOVE
	
	# DUCK
	is_ducking= Input.is_action_pressed("duck")
	# DUCK
	
	#DEBUG
	if Input.is_action_just_pressed("ui_accept"):
		if is_big: _shrink()
		else: _grow()
	#DEBUG

func _animate():
	if animatedSprite.animation in ["convert_small", "convert_big", "convert_fire"] and animatedSprite.is_playing():
		pass
	else:
		if is_big:
			if is_ducking:
				animatedSprite.play("duck_big")
			else:
				if direction: 
					animatedSprite.flip_h = direction<0
					big_fistLeft.disabled = direction<0
					big_fistRight.disabled = direction>0
				if is_on_floor():
					if abs(velocity.x)< SPEED: animatedSprite.play("idle_big")
					else : animatedSprite.play("walk_big")
				else:
					if velocity.y <0: animatedSprite.play("jump_big")
					else:
						if direction: animatedSprite.play("walk_big")
						else: animatedSprite.play("idle_big")
		else:
			if direction: 
				animatedSprite.flip_h = direction<0
				small_fistLeft.disabled = direction<0
				small_fistRight.disabled = direction>0
			if is_on_floor():
				if abs(velocity.x)< SPEED: animatedSprite.play("idle_small")
				else : animatedSprite.play("walk_small")
			else:
				if velocity.y <0: animatedSprite.play("jump_small")
				else:
					if direction: animatedSprite.play("walk_small")
					else: animatedSprite.play("idle_small")

func _grow():	
	animatedSprite.play("convert_big")
	is_big= true
	if is_on_floor(): velocity.y += -10 #FIX UNDER FLOOR
	$CollisionShape2D_big.disabled= false
	$CollisionShape2D_small.disabled= true
	big_fistLeft.disabled= lastDirection<0
	big_fistRight.disabled= lastDirection>0
	small_fistLeft.disabled= true
	small_fistRight.disabled= true

func _shrink():
	animatedSprite.play("convert_small")
	is_big= false
	if is_on_floor(): velocity.y += -200 #FIX UNDER FLOOR
	$CollisionShape2D_small.disabled= false
	$CollisionShape2D_big.disabled= true
	big_fistLeft.disabled= true
	big_fistRight.disabled= true
	small_fistLeft.disabled= lastDirection<0
	small_fistRight.disabled= lastDirection>0

func hit ():
	if is_big: _shrink()
	else: _die()

func _die():
	print ("MARIO DIED")

func _on_hitbox_body_entered(body):
	if body.get_name() in ["Goomba"]:
		if is_on_floor(): hit()
		else: body.hit()

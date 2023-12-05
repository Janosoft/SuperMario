extends StaticBody2D

@onready var animatedSprite = $AnimatedSprite2D

func hit(is_big):
	if is_big: _destroy()
	else: animatedSprite.play("hit")

func _destroy():
	queue_free()

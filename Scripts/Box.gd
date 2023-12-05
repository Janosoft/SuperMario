extends StaticBody2D

var full = true
@onready var animatedSprite = $AnimatedSprite2D

func hit(_is_big):
	if full:
			animatedSprite.play("empty")
			_throw_object()
			full = false

func _throw_object():
	pass

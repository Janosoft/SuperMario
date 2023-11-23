extends StaticBody2D

var full = true
@onready var animatedSprite = $AnimatedSprite2D

func _on_hitbox_area_entered(area):
	if area.get_parent().name == "Mario":
		if full:
			area.get_parent().velocity.x=0
			animatedSprite.play("empty")
			throw_object()
			full = false

func throw_object():
	pass

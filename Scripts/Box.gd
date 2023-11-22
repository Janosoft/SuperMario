extends StaticBody2D

var full = true
@onready var animatedSprite = $AnimatedSprite2D

func _on_hitbox_area_entered(area):
	var hitboxParent = area.get_parent()
	if hitboxParent is CharacterBody2D:
		if full:
			animatedSprite.play("empty")
			throw_object()
			full = false

func throw_object():
	pass

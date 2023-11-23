extends StaticBody2D

@onready var animatedSprite = $AnimatedSprite2D

func _on_hitbox_area_entered(area):
	var hitboxParent = area.get_parent()
	if hitboxParent.name == "Mario":
		area.get_parent().velocity.x=0
		if hitboxParent.is_big: queue_free()
		else:
			animatedSprite.play("hit")


extends StaticBody2D


func _on_hitbox_area_entered(area):
	var hitboxParent = area.get_parent()
	if hitboxParent is CharacterBody2D:
		if hitboxParent.is_big: queue_free()
		

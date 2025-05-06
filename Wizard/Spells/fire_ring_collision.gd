extends Area2D

func hit() -> void:
	$ExplosionSound.play()
	var explosion_area = get_parent().get_node("ExplosionRadius")
	var heroes = explosion_area.get_overlapping_bodies()
	for body in heroes:
		if "hit" in body:
			body.hit(10)


func _on_explosion_sound_finished() -> void:
	get_parent().queue_free()

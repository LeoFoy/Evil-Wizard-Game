extends Node2D

var following_mouse = false
signal shootFireball(pos, direction)

func start_following_mouse():
	following_mouse = true
	set_process_input(true)

func _process(delta: float) -> void:
	if following_mouse:
		global_position = get_global_mouse_position()
		
func _input(event):
	if following_mouse and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		if is_valid_placement():
			following_mouse = false
			Globals.souls -= 10
			var pos: Vector2 = get_tree().current_scene.get_node("SpellCast").global_position
			var direction: Vector2 = (self.global_position - pos).normalized()
			shootFireball.emit(pos, direction)
		else:
			print("Invalid placement!")
			queue_free()

func is_valid_placement() -> bool:
	var minionUI_area = get_tree().current_scene.get_node("MinionUIArea")
	var spellUI_area = get_tree().current_scene.get_node("SpellUIArea")
	
	if spellUI_area and minionUI_area:
		for area in $ExplosionRadius.get_overlapping_areas():
			if area == minionUI_area or area == spellUI_area:
				return false
	return true

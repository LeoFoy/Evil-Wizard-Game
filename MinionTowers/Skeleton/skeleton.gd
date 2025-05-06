extends Node2D

var following_mouse = false
var hero_nearby = false
signal greenFire(pos, direction)
var can_shoot = true
var target_enemy: Node2D = null 
var show_attack_radius: bool = true

func start_following_mouse():
	following_mouse = true
	set_process_input(true)
	
func _ready() -> void:
	queue_redraw()
	set_process(true)

func _process(_delta):
	if following_mouse:
		global_position = get_global_mouse_position()

	if hero_nearby and !following_mouse and can_shoot and target_enemy:
		var pos: Vector2 = $FireSpawner/Marker2D.global_position
		
		var direction: Vector2 = (target_enemy.global_position - pos).normalized()
		
		greenFire.emit(pos, direction)
		
		can_shoot = false
		$AttackCooldown.start()
		
	if !target_enemy:
		check_for_nearest_enemy()

func _input(event):
	if following_mouse and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		if is_valid_placement():
			show_attack_radius = false
			queue_redraw()
			
			following_mouse = false
			Globals.souls -= 1
			print(Globals.souls)
			#set_process(false)
		else:
			print("Invalid placement!")
			queue_free()

func is_valid_placement() -> bool:
	var path_area = get_tree().current_scene.get_node("PathArea")
	var minionUI_area = get_tree().current_scene.get_node("MinionUIArea")
	var spellUI_area = get_tree().current_scene.get_node("SpellUIArea")
	var towerUI_area = get_tree().current_scene.get_node("TowerUIArea")
	
	if path_area and minionUI_area:
		for area in $Area2D.get_overlapping_areas():
			if area == path_area or area == minionUI_area or area == spellUI_area or area == towerUI_area:
				return false
	return true

func check_for_nearest_enemy() -> void:
	var attack_area = $AttackArea.get_node("CollisionShape2D")
	var attack_radius = attack_area.shape.radius
	# Check if there are enemies within the attack radius
	for body in $AttackArea.get_overlapping_bodies():
		var distance = global_position.distance_to(body.global_position)
		if distance <= attack_radius:
			target_enemy = body
			hero_nearby = true
			break


func _on_attack_area_body_exited(body: Node2D) -> void:
	if body == target_enemy:
		target_enemy = null
		hero_nearby = false

func _on_attack_cooldown_timeout() -> void:
	can_shoot = true

func _draw():
	if show_attack_radius:
		var attack_area = $AttackArea.get_node("CollisionShape2D")
		var attack_radius = attack_area.shape.radius
		var center = global_position
		var color = Color(0.2, 0.2, 0.2, 0.3)
		draw_circle(center, attack_radius, color)

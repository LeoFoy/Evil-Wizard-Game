extends Node2D

var skeleton_minion = preload("res://MinionTowers/Skeleton/skeleton.tscn")
var skeleton_fire = preload("res://MinionTowers/Skeleton/skeleton_flame.tscn")
var fireball_spell = preload("res://Wizard/Spells/fire_ring.tscn")
var fireballWhisp = preload("res://Wizard/Spells/fireball.tscn")
var knight_hero = preload("res://Heroes/knight.tscn")
var peasant_hero = preload("res://Heroes/peasant.tscn")

var wave_counter = 1
var wave_started: bool = false
var hero_array = []
var level_failed := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.souls = 600
	Globals.tower_health = 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if level_failed == false:
		check_failure()
	
	$SoulCounter.text = "Souls: " + str(Globals.souls)
	$HealthCounter.text = "Tower Integrity: " + str(Globals.tower_health)
	
	if Globals.souls < 100:
		$SkeletonButton.disabled = true
	else:
		$SkeletonButton.disabled = false
	
	if Globals.souls < 125:
		$FireballButton.disabled = true
	else:
		$FireballButton.disabled = false
	
	for i in range(hero_array.size() - 1, -1, -1):
		if !is_instance_valid(hero_array[i]):
			hero_array.remove_at(i)
	
	if wave_started and hero_array.is_empty():
		wave_started = false
		wave_completed()
		wave_counter += 1
		$StartWave.disabled = false
	
	if wave_counter == 3:
		wave_counter = 4
		$WaveNotif.text = "Victory!"
		Globals.desertLevel_Complete = true
		$VictorySound.play()
		
func check_failure():
	if Globals.tower_health <= 0:
		level_failed = true
		$WaveNotif.modulate.a = 1.0
		$WaveNotif.text = "You have failed..."
		$FailTimer.start()
		

func wave_completed():
	if !(Globals.tower_health <= 0):
		$WaveNotif.modulate.a = 1.0
		$WaveNotif.text = "Wave %d Completed" % wave_counter
		fade_label($WaveNotif, 0.0, 2.0)
		
		
func begin_wave(waveNum):
	randomize() #to randomize seed for random_time
	$WaveNotif.modulate.a = 1.0
	$WaveNotif.text = "Wave %d Start" % wave_counter
	fade_label($WaveNotif, 0.0, 2.0)  
	match waveNum:
		1:
			for i in range(12):
				var random_time = randf_range(0.2, 1.0)
				await get_tree().create_timer(random_time).timeout
				spawn_hero("peasant")
			wave_started = true
		2:
			for i in range(20):
				var random_time = randf_range(0.2, 1.0)
				await get_tree().create_timer(random_time).timeout
				spawn_hero("knight")
			wave_started = true

func spawn_hero(heroType):
	var knight = knight_hero.instantiate()
	var peasant = peasant_hero.instantiate()
	if heroType == "peasant":
		$HeroPath.add_child(peasant)
		hero_array.append(peasant)
		peasant.moving = true
	elif heroType == "knight":
		$HeroPath.add_child(knight)
		hero_array.append(knight)
		knight.moving = true
		
		
func fade_label(label: Label, target_alpha: float, duration: float):
	var tween = get_tree().create_tween()
	tween.tween_property(label, "modulate:a", target_alpha, duration)


func _on_hero_goal_body_entered(body: Node2D) -> void:
	Globals.tower_health -= 10
	body.get_parent().queue_free()


func _on_skeleton_button_button_down() -> void:
	var skeleton = skeleton_minion.instantiate()
	skeleton.connect("greenFire", Callable(self, "skeleton_attack"))
	add_child(skeleton)
	skeleton.start_following_mouse()


func _on_fireball_button_button_down() -> void:
	var fireball = fireball_spell.instantiate()
	fireball.connect("shootFireball", Callable(self, "fireball_attack"))
	add_child(fireball)
	fireball.start_following_mouse()

func skeleton_attack(pos, direction) -> void:
	var fire = skeleton_fire.instantiate() as Area2D
	fire.position = pos
	fire.rotation_degrees = rad_to_deg(direction.angle())
	fire.direction = direction
	add_child(fire)
	
func fireball_attack(pos, direction) -> void:
	var fireSpell = fireballWhisp.instantiate() as Area2D
	fireSpell.position = pos
	fireSpell.rotation_degrees = rad_to_deg(direction.angle())
	fireSpell.direction = direction
	add_child(fireSpell)

func _on_start_wave_pressed() -> void:
	$StartWave.disabled = true
	begin_wave(wave_counter)


func _on_pause_toggled(toggled_on: bool) -> void:
	get_tree().paused = toggled_on
	if toggled_on:
		$Pause/PauseImage.texture = load("res://User Interface/UnPauseButton.png")
	else:
		$Pause/PauseImage.texture = load("res://User Interface/PauseButton.png")


func _on_victory_sound_finished() -> void:
	var level_select = load("res://Scenes/Level_Selection.tscn") as PackedScene
	get_tree().change_scene_to_packed(level_select)


func _on_fail_timer_timeout() -> void:
	print("timer ended")
	var level_select = load("res://Scenes/Level_Selection.tscn") as PackedScene
	get_tree().change_scene_to_packed(level_select)

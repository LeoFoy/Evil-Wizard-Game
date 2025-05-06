extends Node2D

var level

var world_states := {
	0: preload("res://User Interface/NoneDoomed.png"), #None Doomed
	1: preload("res://User Interface/Single Dooms/TundraDoomed.png"), # Tundra only
	2: preload("res://User Interface/Single Dooms/PlainsDoomed.png"), # Plains only
	3: preload("res://User Interface/Double dooms/PlainsTundraDoomed.png"), # Tundra + Plains
	4: preload("res://User Interface/Single Dooms/DesertDoomed.png"), # Desert only
	5: preload("res://User Interface/Double dooms/DesertTundraDoomed.png"), # Tundra + Desert
	6: preload("res://User Interface/Double dooms/DesertPlainsDoomed.png"), # Plains + Desert
	7: preload("res://User Interface/Triple Dooms/PlainsDesertTundraDoomed.png"), # Tundra + Plains + Desert
	8: preload("res://User Interface/Single Dooms/ForestDoomed.png"), # Forest only
	9: preload("res://User Interface/Double dooms/ForestTundraDoomed.png"), # Tundra + Forest
	10: preload("res://User Interface/Double dooms/ForestPlainsDoomed.png"), # Plains + Forest
	11: preload("res://User Interface/Triple Dooms/PlainsForestTundraDoomed.png"), # Tundra + Plains + Forest
	12: preload("res://User Interface/Double dooms/ForestDesertDoomed.png"), # Desert + Forest
	13: preload("res://User Interface/Triple Dooms/DesertForestTundraDoomed.png"), # Tundra + Desert + Forest
	14: preload("res://User Interface/Triple Dooms/DesertForestPlainsDoomed.png"), # Plains + Desert + Forest
	15: preload("res://User Interface/AllDoomed.png")  # All doomed
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_world_map()
	$BackgroundMusic.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Globals.plainsLevel_Complete == true:
		$Plains_Level_Complete.visible = true
		$Plains_Button.disabled = true
	if Globals.desertLevel_Complete == true:
		$Desert_Level_Complete.visible = true
		$Desert_Button.disabled = true
	if Globals.forestLevel_Complete == true:
		$Forest_Level_Complete.visible = true
		$Forest_Button.disabled = true
	if Globals.tundraLevel_Complete == true:
		$Tundra_Level_Complete.visible = true
		$Tundra_Button.disabled = true
	
	

func update_world_map() -> void:
	var state := 0
	if Globals.tundraLevel_Complete:
		state |= 1
	if Globals.plainsLevel_Complete:
		state |= 2
	if Globals.desertLevel_Complete:
		state |= 4
	if Globals.forestLevel_Complete:
		state |= 8

	if state in world_states:
		$Map/MapState.texture = world_states[state]
	else:
		print("Warning: No map texture for state ", state)

func _on_plains_button_pressed() -> void:
	$EnterLevelSFX.play()
	level = load("res://Scenes/plainsLevel1.tscn") as PackedScene

func _on_desert_button_pressed() -> void:
	$EnterLevelSFX.play()
	level = load("res://Scenes/desert_level_1.tscn") as PackedScene

func _on_tundra_button_pressed() -> void:
	$EnterLevelSFX.play()
	level = load("res://Scenes/tundra_level_1.tscn") as PackedScene

func _on_forest_button_pressed() -> void:
	$EnterLevelSFX.play()
	level = load("res://Scenes/forest_level_1.tscn") as PackedScene
	
func _on_enter_level_sfx_finished() -> void:
	get_tree().change_scene_to_packed(level)

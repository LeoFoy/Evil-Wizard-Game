extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$BackgroundMusic.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	$VBoxContainer/LevelSelect_Button/SelectSound1.play()


func _on_quit_button_pressed() -> void:
	$VBoxContainer/Quit_Button/SelectSound2.play()
	


func _on_select_sound_finished() -> void:
	var new_scene = load("res://Scenes/Level_Selection.tscn") as PackedScene
	get_tree().change_scene_to_packed(new_scene)


func _on_select_sound_2_finished() -> void:
	get_tree().quit()

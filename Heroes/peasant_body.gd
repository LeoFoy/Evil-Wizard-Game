extends CharacterBody2D

var hp = 1
var damage = 0

func hit(amount):
	$HitNoise.play() 
	damage = amount 
	  


func _on_hit_noise_finished() -> void:
	hp -= damage
	if hp <= 0:
		Globals.souls += 1
		get_parent().queue_free()

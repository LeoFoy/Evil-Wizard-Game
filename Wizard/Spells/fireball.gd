extends Area2D

var speed = 1000
var direction: Vector2

func _process(delta: float) -> void:
	position += direction * speed * delta


func _on_area_entered(area: Area2D) -> void:
	if "hit" in area:
		area.hit()
		queue_free()

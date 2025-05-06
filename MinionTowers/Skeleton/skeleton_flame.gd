extends Area2D

var speed = 500
var direction: Vector2

func _process(delta: float) -> void:
	position += direction * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if "hit" in body:
		body.hit(1)
	queue_free()

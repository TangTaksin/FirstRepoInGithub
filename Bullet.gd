extends Area2D

class_name bullet

var speed: float = 600
var direction: int


func _physics_process(delta: float) -> void:
	move_local_x(direction * speed * delta)

func _on_timer_timeout() -> void:
	queue_free()

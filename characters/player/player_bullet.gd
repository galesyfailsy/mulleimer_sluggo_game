extends Area2D

const SPEED = 640.0
var distance = 0.0

func _physics_process(delta: float) -> void:
	position += transform.basis_xform(delta * SPEED * Vector2.RIGHT)
	distance += delta * SPEED
	if distance > 64.0 * 6: queue_free()

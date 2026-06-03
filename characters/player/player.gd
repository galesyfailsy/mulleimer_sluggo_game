extends Node2D

@onready var wallray: RayCast2D = $RayCast2D
@onready var sprite: AnimatedSprite2D = $sprite

const BULLET = preload("uid://dyb6eek762u0v")

const TILE_TRAVEL_TIME = 0.5

var coordinates = Vector2i.ZERO
var previous_target = Vector2i.ZERO
var current_target = Vector2i.ZERO:
	set(vi):
		previous_target = current_target
		current_target = vi
var direction = Vector2.RIGHT

func _ready() -> void:
	coordinates = NavigationSystem.local_to_grid(coordinates)

func _process(delta: float) -> void:
	if global_position.distance_squared_to(NavigationSystem.grid_to_local(current_target)) > 1:
		global_position = global_position.move_toward(NavigationSystem.grid_to_local(current_target), NavigationSystem.astar.cell_size.x * delta / TILE_TRAVEL_TIME)
		if sprite.animation != &"walk": sprite.play("walk")
	else:
		global_position = NavigationSystem.grid_to_local(current_target)
		coordinates = current_target
		var previous_direction = direction
		if Input.is_action_just_pressed("fire"):
			var b = BULLET.instantiate()
			add_child(b)
			b.rotation = direction.angle()
			b.position = global_position
		elif Input.is_action_pressed("left"):
			direction = Vector2.LEFT
			sprite.flip_h = true
		elif Input.is_action_pressed("right"):
			direction = Vector2.RIGHT
			sprite.flip_h = false
		elif Input.is_action_pressed("up"):
			direction = Vector2.UP
		elif Input.is_action_pressed("down"):
			direction = Vector2.DOWN
		
		if sprite.animation != &"default": sprite.play("default")
		
		if previous_direction != direction:
			wallray.target_position = direction * NavigationSystem.astar.cell_size.x
			if !wallray.is_colliding(): current_target = coordinates + Vector2i(direction)
		direction = Vector2.ZERO
	

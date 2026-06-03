extends Node

var astar = AStarGrid2D.new()

func _ready() -> void:
	astar.cell_size = Vector2(64,64)
	astar.offset = astar.cell_size / 2.0
	astar.region = Rect2i(-Vector2i(32,32), Vector2i(64,64))
	astar.update()

func get_point_path(start: Vector2, end: Vector2) -> PackedVector2Array:
	var from = local_to_grid(start)
	var to = local_to_grid(end)
	return astar.get_point_path(from, to)

func local_to_grid(coord: Vector2) -> Vector2i:
	return Vector2i((coord / (astar.cell_size + astar.offset)).floor())

func grid_to_local(coord: Vector2i) -> Vector2:
	return Vector2(coord) * astar.cell_size

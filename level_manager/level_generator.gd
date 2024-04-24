class_name LevelGenerator
extends Node

var rng = RandomNumberGenerator.new()
var constants : LevelConstants

func _init(level_constants):
	constants = level_constants
	super._init()

func update_level(level):
	var margin_points = generate_margin_shape()
	var packed_margin_points = PackedVector2Array(margin_points)
	level.left_margin.polygon.set_polygon(packed_margin_points)
	level.left_margin.collision_shape.set_polygon(packed_margin_points)
	level.right_margin.polygon.set_polygon(packed_margin_points)
	level.right_margin.collision_shape.set_polygon(packed_margin_points)
	level.background.position.y = -constants.LEVEL_SIZE

func generate_new_level():
	var margin_points = generate_margin_shape()
	var packed_margin_points = PackedVector2Array(margin_points)
	var level = create_level_from_points(packed_margin_points)
	return level

func create_level_from_points(packed_margin_points):
	var level = Level.new(constants)
	level.left_margin = create_margin_land(packed_margin_points, false)
	level.right_margin = create_margin_land(packed_margin_points, true)
	level.background = generate_background(-constants.LEVEL_SIZE)
	return level

func generate_background(position_y):
	var background = ColorRect.new()
	background.modulate = Color8(0, 177, 164, 255)
	background.size.x = constants.TOTAL_WIDTH
	background.size.y = constants.LEVEL_SIZE
	background.position.x = 0
	background.position.y = position_y
	background.z_index = -1
	return background

func create_margin_land(packed_margin_points, is_rightside):
	var margin_polygon = Polygon2D.new()
	margin_polygon.set_polygon(packed_margin_points)
#	margin_polygon.modulate = Color8(0, 180, 20, 150)
	margin_polygon.modulate = Color.DARK_GREEN
	var margin_collision_polygon = CollisionPolygon2D.new()
	margin_collision_polygon.set_polygon(packed_margin_points)
	if is_rightside:
		margin_polygon.scale.x = -1
		margin_polygon.translate(Vector2(constants.TOTAL_WIDTH, 0.))
		margin_collision_polygon.scale.x = -1
		margin_collision_polygon.translate(Vector2(constants.TOTAL_WIDTH, 0.))
	var land = Land.new()
	land.polygon = margin_polygon
	land.collision_shape = margin_collision_polygon
	land.add_to_group("obstacle")
	return land

func generate_margin_shape():
	var margin_points = Array()
	margin_points.append(Vector2(0., 0.))
	margin_points.append(Vector2(constants.MAX_MARGIN_WIDTH, 0.))
	margin_points.append(Vector2(constants.MAX_MARGIN_WIDTH, 0. -constants.PLANE_SIZE))
	for i in range(1, constants.POINTS_IN_MARGIN_POLYGON):
		var point_y = - i * constants.LEVEL_SIZE / constants.POINTS_IN_MARGIN_POLYGON
		var point_x = margin_points[-1].x
		if i == 0 || i == constants.POINTS_IN_MARGIN_POLYGON || \
		rng.randf_range(0.0, 1.0) > constants.MARGIN_STABILITY_RATE:
			point_x = rng.randf_range(constants.MIN_MARGIN_WIDTH, constants.MAX_MARGIN_WIDTH)
		margin_points.append(Vector2(point_x, point_y))
	margin_points.append(Vector2(constants.MAX_MARGIN_WIDTH, -constants.LEVEL_SIZE + constants.PLANE_SIZE))
	margin_points.append(Vector2(constants.MAX_MARGIN_WIDTH, -constants.LEVEL_SIZE))
	margin_points.append(Vector2(0., -constants.LEVEL_SIZE))
	return margin_points

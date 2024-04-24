class_name MobSpawner
extends Node

enum {BOAT, CHOPPER, JET, FUEL_STATION}
const MAX_MOB_AMOUNT = {
	BOAT: 10.,
	CHOPPER: 10.,
	JET: 5.,
	FUEL_STATION: 4.
}

var boat_resource = preload("res://mobs/boat/boat.tscn")
var chopper_resource = preload("res://mobs/chopper/chopper.tscn")
var jet_resource = preload("res://mobs/jet/jet.tscn")
var fuel_station_resource = preload("res://mobs/fuel_station/fuel_station.tscn")
var rng = RandomNumberGenerator.new()
var constants : LevelConstants
var vertex_table: Dictionary

func _init(level_constants):
	constants = level_constants
	super._init()
	
func populate_level(level):
	prepare_vertex_table(level)
	for i in range(MAX_MOB_AMOUNT[BOAT]):
		spawn_or_relocate(level, BOAT, i)
	for i in range(MAX_MOB_AMOUNT[CHOPPER]):
		spawn_or_relocate(level, CHOPPER, i)
	for i in range(MAX_MOB_AMOUNT[JET]):
		spawn_or_relocate(level, JET, i)
	for i in range(MAX_MOB_AMOUNT[FUEL_STATION]):
		spawn_or_relocate(level, FUEL_STATION, i)

func prepare_vertex_table(level):
	vertex_table = {}
	for vertex in level.left_margin.polygon.polygon:
		if !vertex_table.has(vertex.y) || vertex.x > vertex_table[vertex.y]:
			vertex_table[vertex.y] = vertex.x

func decide_position(mob_type):
	var chunk = rng.randi_range(0, constants.POINTS_IN_MARGIN_POLYGON - 1)
	var chunk_size = constants.LEVEL_SIZE / constants.POINTS_IN_MARGIN_POLYGON
	var y = chunk * chunk_size + rng.randf_range(0., chunk_size)
	var lower_point = - chunk * chunk_size
	var higher_point = lower_point - chunk_size
	var x_min = vertex_table[lower_point]
	if abs(vertex_table[lower_point] - vertex_table[higher_point]) > 0.1:
		var big_triangle_y = chunk_size
		var big_triangle_x = abs(vertex_table[lower_point] - vertex_table[higher_point])
		var small_triangle_y = \
			abs(higher_point + y) if vertex_table[lower_point] > vertex_table[higher_point] \
			else abs(- y - lower_point)
		x_min = min(vertex_table[lower_point], vertex_table[higher_point]) + \
			big_triangle_x * small_triangle_y / big_triangle_y
	var mob_width = get_mob_width(mob_type)
	var x = rng.randf_range(x_min + mob_width, constants.TOTAL_WIDTH - x_min - mob_width)
	return Vector2(x, - y)

func get_mob_width(mob_type):
	return constants.PLANE_SIZE

func spawn_or_relocate(level, mob_type, index):
	if (level.mobs[mob_type].size() <= index):
		var mob = create_mob(mob_type)
		level.mobs[mob_type].append(mob)
		level.add_child(mob)
	var mob_position = decide_position(mob_type)
	level.mobs[mob_type][index].position = mob_position
	level.mobs[mob_type][index].reset()

func create_mob(mob_type):
	var mob
	if mob_type == BOAT:
		mob = boat_resource.instantiate()
	if mob_type == CHOPPER:
		mob = chopper_resource.instantiate()
	if mob_type == JET:
		mob = jet_resource.instantiate()
	if mob_type == FUEL_STATION:
		mob = fuel_station_resource.instantiate()
		mob.add_to_group("fuel")
	if mob is Enemy:
		mob.set_rng(rng)
		mob.add_to_group("obstacle")
	return mob

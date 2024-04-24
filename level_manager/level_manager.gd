extends Node2D

signal updated_levels_behind

var constants = LevelConstants.new()
var generator = LevelGenerator.new(constants)
var mob_spawner = MobSpawner.new(constants)
var levels = Array()
var window_y = DisplayServer.window_get_size().y
var current_level = 0
var first_level = true

# Called when the node enters the scene tree for the first time.
func _ready():
	levels.append(generator.generate_new_level())
	levels.append(generator.generate_new_level())
	mob_spawner.populate_level(levels[0])
	mob_spawner.populate_level(levels[1])
	levels[0].set_vertical_position(window_y)
	levels[1].set_vertical_position(window_y - constants.LEVEL_SIZE)
	add_child(levels[0])
	add_child(levels[1])
	levels[0].add_nodes_to_tree()
	levels[1].add_nodes_to_tree()

func _on_player_accelerated():
	for level in levels:
		level.set_velocity(Vector2(0.0, 150.0))

func _on_player_returned_to_default_speed():
	for level in levels:
		level.set_velocity(Vector2(0.0, 100.0))

func _on_player_slowed_down():
	for level in levels:
		level.set_velocity(Vector2(0.0, 50.0))

func _on_player_died():
	for level in levels:
		level.set_velocity(Vector2(0.0, 0.0))

func _on_player_respawned():
	levels[current_level].set_vertical_position(window_y)
	levels[1 - current_level].set_vertical_position(window_y - constants.LEVEL_SIZE)
	_on_player_returned_to_default_speed()

func _on_level_crossed_swapping_point():
	levels[current_level].set_vertical_position(0.)
	generator.update_level(levels[current_level])
	mob_spawner.populate_level(levels[current_level])
	var other_level_position = levels[1 - current_level].position.y
	levels[current_level].set_vertical_position(other_level_position - constants.LEVEL_SIZE)
	current_level += 1
	current_level %= 2


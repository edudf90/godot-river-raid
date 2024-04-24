class_name Level 
extends Node2D

var left_margin : Land
var right_margin : Land
var contains_island = false
var island_list = Array()
var background : ColorRect
var movement_component : MovementComponent
var velocity : Vector2
var constants : LevelConstants
var swapping_point
var mobs : Array = Array()

signal crossed_swapping_point


func _init(level_constants):
	constants = level_constants
	swapping_point = DisplayServer.window_get_size().y + constants.LEVEL_SIZE
	for i in range(constants.MOB_TYPES):
		mobs.append(Array())
	super._init()
	
func _ready():
	movement_component = MovementComponent.new()
	velocity = Vector2(0.0, 100.0)
	movement_component.actor = self
	movement_component.velocity = velocity

func add_nodes_to_tree():
	add_child(left_margin)
	add_child(right_margin)
	add_child(background)
	left_margin.add_nodes_to_tree()
	right_margin.add_nodes_to_tree()
	crossed_swapping_point.connect(get_parent()._on_level_crossed_swapping_point)

func _physics_process(delta):
	if position.y > swapping_point:
		crossed_swapping_point.emit()
	movement_component.process(delta)

func set_velocity(new_velocity : Vector2):
	self.velocity = new_velocity
	movement_component.velocity = new_velocity

func set_vertical_position(vertical_position):
	position.y = vertical_position
	#translate(Vector2(0.0, vertical_position - position.y))

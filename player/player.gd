class_name Player
extends Node2D

const HORIZONTAL_SPEED = 100.0
const MAX_SHOTS = 12

signal accelerated
signal slowed_down
signal returned_to_default_speed
signal died
signal respawned
signal entered_fuel_station
signal left_fuel_station

var starting_y = position.y
var starting_x = position.x
var player_alive = true
var velocity : Vector2
var shots : Array = Array()
var shot_resource = preload("res://shot/shot.tscn")
var shooting_cooldown_over = true

func _ready():
	$Area2D.connect("body_entered", handle_collision)
	$Area2D.connect("area_entered", handle_collision)
	$Area2D.connect("area_exited", handle_leaving_area)
	died.connect(get_parent().on_player_hit)

func _physics_process(delta):
	if player_alive:
		if Input.is_action_just_pressed("ui_accept"):
			shoot()
		if Input.is_action_just_pressed("ui_up"):
			accelerated.emit()
		if Input.is_action_just_pressed("ui_down"):
			slowed_down.emit()
		if Input.is_action_just_released("ui_up") || \
		Input.is_action_just_released("ui_down"):
			returned_to_default_speed.emit()
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * HORIZONTAL_SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, HORIZONTAL_SPEED)
	$MovementComponent.velocity = velocity
	$MovementComponent.process(delta)

func shoot():
	if shooting_cooldown_over:
		var shot
		if shots.size() < MAX_SHOTS:
			shot = shot_resource.instantiate()
			get_tree().get_first_node_in_group("game").add_child(shot)
		else:
			shot = shots.pop_front()
		var top = position.y + $Area2D/CollisionShape2D.shape.size.y / 2
		shot.get_fired(Vector2(position.x, top))
		shots.push_back(shot)
		shooting_cooldown_over = false
		$ShootingCooldown.start(0.5)

func handle_leaving_area(collider : Node2D):
	if player_alive && collider != null && collider.is_in_group("fuel"):
		left_fuel_station.emit()

func handle_collision(collider : Node2D):
	if player_alive && collider != null:
		if collider.is_in_group("fuel"):
			entered_fuel_station.emit()
		elif collider.is_in_group("obstacle"):
			die()

func die():
	velocity = Vector2(0.0, 0.0)
	$MovementComponent.velocity = velocity
	$Sprite2D.visible = false
	$Explosion.emitting = true
	player_alive = false
	died.emit()
	$Timer.start(2)

func _on_timer_timeout():
	respawned.emit()
	position.x = starting_x
	position.y = starting_y
	$Sprite2D.visible = true
	player_alive = true
	$Timer.stop()

#func _on_level_manager_updated_levels_behind():
#	position.y += 2 * Constants.LEVEL_SIZE
#	next_milestone += 2 * Constants.LEVEL_SIZE
#	updated_position.emit()


func _on_shooting_cooldown_timeout():
	shooting_cooldown_over = true
	$ShootingCooldown.stop()

extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("game")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_mob_hit():
	$Score.increment()

func on_player_hit():
	$Lives.decrement()
	$Fuel.stop()

func end_game():
	$Score.reset()
	$Lives.reset()

func _on_fuel_empty():
	$Player.die()

func _on_player_respawned():
	$Fuel.reset()

func _on_player_entered_fuel_station():
	$Fuel.start_fuelling()

func _on_player_left_fuel_station():
	$Fuel.start_burning_fuel()


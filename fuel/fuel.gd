extends Node2D

const MAX_FUEL = 300.
const DECREASING_RATE = -3.0
const INCREASING_RATE = 10.0

var current_fuel
var increasing
var decreasing
var stopped

signal empty

# Called when the node enters the scene tree for the first time.
func _ready():
	reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !stopped:
		if increasing && current_fuel < MAX_FUEL:
			current_fuel += INCREASING_RATE * delta
		elif decreasing && current_fuel > 0.:
			current_fuel += DECREASING_RATE * delta
		if current_fuel > 0.:
			$ColorRect.size.x = current_fuel
		else :
			empty.emit()
			stop()

func reset():
	current_fuel = MAX_FUEL
	$ColorRect.size.x = MAX_FUEL
	start_burning_fuel()

func stop():
	increasing = false
	decreasing = false
	stopped = true

func start_fuelling():
	increasing = true
	decreasing = false
	stopped = false

func start_burning_fuel():
	increasing = false
	decreasing = true
	stopped = false

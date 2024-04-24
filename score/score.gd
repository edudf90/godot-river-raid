extends Node2D

var score : int
# Called when the node enters the scene tree for the first time.
func _ready():
	reset()

func reset():
	score = 0
	refresh_label()

func increment():
	score += 1
	refresh_label()

func refresh_label():
	$Label.text = str(score)

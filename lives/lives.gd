extends Node2D

var lives

signal no_lives_left

func _ready():
	no_lives_left.connect(get_parent().end_game)
	reset()

func reset():
	lives = 3
	refresh_label()

func increment():
	lives += 1
	refresh_label()

func decrement():
	if lives == 0:
		no_lives_left.emit()
	else:
		lives -= 1
		refresh_label()

func refresh_label():
	$Label.text = " X " + str(lives)

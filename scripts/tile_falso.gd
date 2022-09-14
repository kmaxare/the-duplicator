extends StaticBody2D

var vida = 3

func _ready():
	pass

func romper():
	vida -= 1
	
	match vida:
		2: $Sprite_tile.frame = 0
		1: $Sprite_tile.frame = 1
	
	if vida == 0:
		queue_free()
	
	

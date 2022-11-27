extends KinematicBody2D

var velocidad = 180 # Definido por escena pistola

var direccion = 0 # Direccion y pocicion de pistola, es modificado directamente por la pistola

func _ready():
	pass

func _process(delta):
	var move
	match direccion:
		0: move = move_and_collide(Vector2(-1*velocidad * delta, 0))
		1: move = move_and_collide(Vector2(1*velocidad * delta, 0))
		2: move = move_and_collide(Vector2(0, -1*velocidad * delta))
		3: move = move_and_collide(Vector2(0, 1*velocidad * delta))
	
	if move != null: # Si coliciona
		if move.collider.is_in_group("proceso"):
			move.collider.muerte('pistola')
			
		elif move.collider.is_in_group("tile_falso"):
			move.collider.romper()
			
		elif move.collider.is_in_group("ojo_maq"):
			move.collider.romper_ojo()
			
		else:
			$anim_bala.play("choque")
			yield($anim_bala,"animation_finished")
			
		self.queue_free()

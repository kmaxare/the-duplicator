extends Area2D

export var dir_disparo = 0

func _ready():
	dir_tubo(dir_disparo)

func _on_tubos_body_entered(body):
	if body.is_in_group("bala"):
		if body.direccion != dir_disparo:
			body.direccion = dir_disparo
	if body.is_in_group("personaje"):
		print (dir_disparo)
		girar()
	

func dir_tubo(dir_disparo):
	match dir_disparo:
		0: #izquierda
			$Sprite_tubo.frame = 1
		1: #derecha
			$Sprite_tubo.frame = 3
		2: #arriba
			$Sprite_tubo.frame = 0
		3:# abajo
			$Sprite_tubo.frame = 2

func girar():
	dir_disparo += 1
	if dir_disparo == 4: dir_disparo = 0
	dir_tubo(dir_disparo)

extends Node2D
var active = true

func _ready():
	pass

func _process(delta):
	if $izq.is_colliding() and $der.is_colliding() or $center.is_colliding():
		get_parent().null_salto() #Anulamos el salto
	elif active:
		if !$izq.is_colliding() and $der.is_colliding() and !$center.is_colliding():
			get_parent().movPosition(false) #false: Movimiento izquierda / true: Movimiento derecho
		elif $izq.is_colliding() and !$der.is_colliding() and !$center.is_colliding():
			get_parent().movPosition(true) #false: Movimiento izquierda / true: Movimiento derecho
		active = false

	if $back_izq.is_colliding() and $back_der.is_colliding():
		if get_parent().raycast_back != true:
			get_parent().raycast_back = true
	elif !$back_izq.is_colliding() and !$back_der.is_colliding():
		if get_parent().raycast_back != false:
			get_parent().raycast_back = false

extends Node2D
var active = true

func _ready():
	pass

func _process(delta):
	if $raycastIzq.is_colliding() and $raycastDer.is_colliding() or $raycastCenter.is_colliding():
		get_parent().null_salto() #Anulamos el salto
	elif active:
		if !$raycastIzq.is_colliding() and $raycastDer.is_colliding() and !$raycastCenter.is_colliding():
			get_parent().movPosition(false) #false: Movimiento izquierda / true: Movimiento derecho
		elif $raycastIzq.is_colliding() and !$raycastDer.is_colliding() and !$raycastCenter.is_colliding():
			get_parent().movPosition(true) #false: Movimiento izquierda / true: Movimiento derecho
		active = false

	if $raycastBack.is_colliding():
		if get_parent().raycast_back != true:
			get_parent().raycast_back = true
	else:
		if get_parent().raycast_back != false:
			get_parent().raycast_back = false

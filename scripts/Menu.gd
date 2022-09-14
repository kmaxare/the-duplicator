extends Control

var menu_activo = true
var cant_boot = 0 # Cantidad de botones
var boton_select = 1 # Boton seleccionado actual

func _ready():
	$Autor/anim_per.play("size")
	yield($Autor/anim_per, "animation_finished")
	select_boton()
	cant_boot = get_tree().get_nodes_in_group("boton").size()
	
	
func _process(delta): # Seleccion dentro del menu
	if menu_activo:
		if Input.is_action_just_pressed("ui_right"):
			if boton_select < cant_boot: boton_select += 1
			else: boton_select = 1
			select_boton()
		elif Input.is_action_just_pressed("ui_left"):
			if boton_select > 1: boton_select -= 1
			else: boton_select = cant_boot
			select_boton()
		if Input.is_action_just_pressed("espacio"): # press
			menu_activo = false
			if boton_select == 1:
				get_tree().change_scene("res://Game.tscn")
			if boton_select == 2:
				_creditos()
				menu_activo = true

func select_boton():
	for i in range(cant_boot): # Paramos animaciones de los botones
		get_tree().get_nodes_in_group("boton")[i].get_node("anim").play("quieto")
		get_tree().get_nodes_in_group("boton")[i].get_node("anim").play("quieto")
		
	match boton_select: # Reproducimos una animacion
		1: $Boton/anim.play("select")
		2: $Boton2/anim.play("select")
#		3: $Botones/prueba/anim_punt.play("select")

func reproduccion_anim(x):
	match x:
		0: $caratula/anim_caratula.play("moov")
		1: $caratula/anim_caratula.stop()
		
func _creditos():
	desenfoque(false)
	$Autor.text = "Made by"
	$Autor/instruc.visible = false
	$Autor/logo.visible = true
	$Autor/autors.visible = true
	desenfoque(true)
	yield(get_tree().create_timer(3),"timeout")
	instrucciones()
	
func instrucciones():
	desenfoque(false)
	$Autor.text = "Keys to play:"
	$Autor/instruc.visible = true
	$Autor/logo.visible = false
	$Autor/autors.visible = false
	desenfoque(true)
	$Autor/anim_per.play("size")
	yield($Autor/anim_per, "animation_finished")
	select_boton()
	
func desenfoque(activado):
#	if activado: $Autor/anim_per.play("enfoque_salida")
#	elif !activado: $Autor/anim_per.play("desenfoque_entrada")
##	yield($Autor/anim_per,"animation_finished")
#	yield(get_tree().create_timer(1.5),"timeout")
	pass

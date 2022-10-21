extends Node2D

var num_puntos
var num_pistolas
var num_rashos

var bloqueo = true # bloquea algunas acciones de teclas del nivel

func _ready():
	num_puntos = get_tree().get_nodes_in_group("spawn").size()
	num_pistolas = get_tree().get_nodes_in_group("pistola").size()
	num_rashos = get_tree().get_nodes_in_group("rashos_laser").size()
	print (num_rashos)
	
func desac_coll():
	for i in get_tree().get_nodes_in_group("port").size():
		get_tree().get_nodes_in_group("port")[i].get_node("CollisionShape2D").disabled = true

func _process(delta):
	if Input.is_action_just_pressed("Reset"):
		GameHundler._reset = true
		GameHundler.game_over()
	if Input.is_action_just_pressed("main"):
		GameHundler.nivel_act = 1
		get_tree().change_scene("res://scenas/Main.tscn")
		
	if Input.is_action_just_pressed("espacio") and !bloqueo:
		for x in get_tree().get_nodes_in_group("personaje").size():
			if get_tree().get_nodes_in_group("personaje")[x]:
				if get_tree().get_nodes_in_group("personaje")[x]._move_swich:
					get_tree().get_nodes_in_group("personaje")[x].muerte('pincho')
				bloqueo = true
				$personaje._move_swich = true
				
		
func escenas(value):
	match value:
		0: print("escena uno") # Se trabo el jugador
		1: 
			$Control._text(1)
			$Control._text(2)
	

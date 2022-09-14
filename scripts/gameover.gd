extends Control

func _ready():
	pass


func _on_refresh_pressed():
	print (GameHundler.nivel_act)
	match GameHundler.nivel_act:
		1: get_tree().change_scene("res://scenas/niveles/Escenario_1.tscn")
		2: get_tree().change_scene("res://scenas/niveles/Escenario_2.tscn")
		3: get_tree().change_scene("res://scenas/niveles/Escenario_3.tscn")

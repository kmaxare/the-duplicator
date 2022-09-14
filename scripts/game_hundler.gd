extends Node

#setget para que cadaves que cambiamos el valor de la variable se ejecute la funcion
#var nivel_act: int = 0 setget current_level_changed
var nivel_act = 1

var _reset = false # Variable que permite recetear el nivel sin haver perdido

var data_game = {
	'nivel_act': nivel_act
}

func _ready():
#	load_game()
	pass
	
func game_over():
	var num_pers = get_tree().get_nodes_in_group("personaje").size()
	if int(num_pers) == 1 or _reset == true:
#		get_tree().change_scene("res://scenas/mains/gameover.tscn")
		cargar_nivel()
		_reset = false

func current_level_changed(level): # Asignacion de valores para guardar
	nivel_act = level
	data_game['nivel_act'] = nivel_act
	save_game()

func save_game():
	var file = File.new()
	file.open('res://data.save', File.WRITE) #Primer valor creara un archivo "data.save, segundo parametro que accion queremos tener con el archivo"
	#Permite guardar una nueva linea de datos
	file.store_line(to_json(data_game))
	file.close()
	
func load_game():
	var file = File.new()
	if file.file_exists('res://data.save'): # Si existe un archivo en esta ruta con este nombre
		file.open('res://data.save', File.READ) # Habre la ruta
	else: # Si no existe retornamos
		return
	
	while file.get_position() < file.get_len():
		var dataJson = parse_json(file.get_line())
		nivel_act = dataJson['nivel_act'] # Actualizamos variable vacia deacuerdo al documento
	file.close()
	
func cargar_nivel():
	
	match GameHundler.nivel_act:
		0: get_tree().change_scene("res://scenas/niveles/Escenario_1.tscn")
		1: get_tree().change_scene("res://scenas/niveles/nivel_uno.tscn")
		2: get_tree().change_scene("res://scenas/niveles/nivel_dos.tscn")
		3: get_tree().change_scene("res://scenas/niveles/nivel_tres.tscn")
		4: get_tree().change_scene("res://scenas/niveles/nivel_cuatro.tscn")
		5: get_tree().change_scene("res://scenas/niveles/nivel_cinco.tscn")
		6: get_tree().change_scene("res://scenas/niveles/nivel_seis_ofi.tscn")
		7: get_tree().change_scene("res://scenas/niveles/Nivel_final.tscn")

func LVniveles_C(): #uno
	# Nivel final
	pass

func LVniveles_D(): #dos
	pass

func LVniveles_usb(): #tres
	pass

func LVniveles_lan(): #cuatro
	pass

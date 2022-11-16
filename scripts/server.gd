extends Area2D

export var tope_server = 4
export var id_server = 0

var num_proces = 0

enum tipo_informe {funcional, error, contador}
var server_est = tipo_informe

var arrayPer = []
var timer_node # Variable para almacenar nodo timer

func _ready():
	server_est = tipo_informe.funcional
	refresh_text()


func _physics_process(delta):
	pass


func _on_server_body_entered(body):
	if !body.is_in_group("proceso"): return
	
	num_proces += 1
	
	if not body.id_per in arrayPer:
		arrayPer.append(body.id_per)

	if num_proces < tope_server: # Si el servidor no esta a tope funciona
		get_parent().get_parent().get_node("SFX/cont_server").play()
		refresh_text()

	elif num_proces >= tope_server:
		informe_server(tipo_informe.error)
		if server_est == tipo_informe.error: contador_reinicio() # Empieza el conteo 


func _on_server_body_exited(body):
	if not body.is_in_group("proceso"): return
	
	for id in range(len(arrayPer)):
		if arrayPer[id] == body.id_per: arrayPer.remove(id)

	if num_proces > 0:
		num_proces -= 1
	if num_proces < 1:
		num_proces = 0 # Si el numero de procesos pasa a negativo entonces lo transformamos a 0
		pistola_server(false) #Apagamos el eliminador de virus
		informe_server(tipo_informe.funcional)
	refresh_text()


func informe_server(param_server_est):
	if $anim_text.play(): $anim_text.stop() #Si alguna animacion se ejecuta, la paramos
	
	match param_server_est:
		tipo_informe.funcional:
			server_est = tipo_informe.funcional
			for i in get_parent().get_parent().num_rashos: #Activacion defensas
				get_tree().get_nodes_in_group("rashos_laser")[i]._activo()
			
		tipo_informe.error:
			server_est = tipo_informe.error
#			$text.text = "ERROR"
#			yield(get_tree().create_timer(1), "timeout")
			for i in get_parent().get_parent().num_rashos:
				get_tree().get_nodes_in_group("rashos_laser")[i]._apagado()

		tipo_informe.contador:
			server_est = tipo_informe.contador
			$timer_node.start()


func refresh_text():
	if server_est == tipo_informe.funcional:
		$text.text = str(num_proces)+ "/" +str(tope_server)
	elif server_est == tipo_informe.contador:
		$text.text = 'ERROR'


func contador_reinicio():
	informe_server(tipo_informe.contador) #Tipo de informe del servidor y texto a imprimir
	refresh_text()


func pistola_server(interruptor_stado):
	if get_parent().get_parent().num_pistolas <= 0: return # Si no existen pistolas
		
	for pistol in get_parent().get_parent().num_pistolas:
		if get_tree().get_nodes_in_group("pistola")[pistol].tipe_pistoll == 1:
			if interruptor_stado:
				get_tree().get_nodes_in_group("pistola")[pistol].estado_pistola = true
			elif !interruptor_stado:
				get_tree().get_nodes_in_group("pistola")[pistol].estado_pistola = false


func matar_procesos():
	if len(arrayPer) > 0: # Si existen procesos
		var procesos_size = get_tree().get_nodes_in_group("proceso").size()
		for value in range(procesos_size):
			if (get_tree().get_nodes_in_group("proceso")[value].id_per in arrayPer):
				get_tree().get_nodes_in_group("proceso")[value].muerte('servidor')


func _on_timer_node_timeout():
	informe_server(tipo_informe.funcional)
	matar_procesos()
	refresh_text()

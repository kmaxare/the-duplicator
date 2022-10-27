extends Area2D

export var tope_server = 4
export var id_server = 0
export var time_server = 6

var num_proces = 0

enum tipo_informe {funcional, error, contador}
var server_est = tipo_informe

var arrayUser = []

func _ready():
	server_est = tipo_informe.funcional
	refresh()
	
func _physics_process(delta):
	print(arrayUser)

func _on_server_body_entered(body):
	if !body.is_in_group("proceso"): return

	if num_proces < tope_server: # Si el servidor no esta a tope funciona
		num_proces += 1
		arrayUser.append(body.id)
		get_parent().get_parent().get_node("SFX/cont_server").play()
		refresh()

	elif num_proces >= tope_server:
		num_proces += 1
		informe_server(tipo_informe.error)
		if server_est == tipo_informe.funcional or server_est == tipo_informe.error: contador_reinicio() # Empieza el conteo 
			
			
func _on_server_body_exited(body):
#	if body.is_in_group("proceso") and num_proces:
	if body.is_in_group("proceso"): #Si es (player/npc) y ingreso un cuerpo
		arrayUser.remove(body)
		if num_proces > 0: num_proces -= 1
		if num_proces < 0: num_proces = 0 # Si el numero de procesos pasa a negativo entonces lo transformamos a 0
		if num_proces == 0:
			pistola_server(false) #Apagamos el eliminador de virus
			informe_server(tipo_informe.funcional)
		refresh()
		

func informe_server(param_server_est, num_contador = 0):
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
			match num_contador:
				0: $text.text = "******"
				1: $text.text = "*****"
				2: $text.text = "****"
				3: $text.text = "***"
				4: $text.text = "**"
				5:
					$text.text = "*"
					yield(get_tree().create_timer(1),"timeout")
					pistola_server(true)
					informe_server(tipo_informe.funcional)

func refresh():
	if server_est == tipo_informe.funcional:
		$text.text = str(num_proces)+ "/" +str(tope_server)

func contador_reinicio():
	for x in time_server:
		informe_server(tipo_informe.contador, x) #Tipo de informe del servidor y texto a imprimir
		yield(get_tree().create_timer(1), "timeout") # Apagando de servidor
		refresh()
	informe_server(tipo_informe.funcional)

func pistola_server(interruptor_stado):
	if get_parent().get_parent().num_pistolas <= 0: # Si no existen pistolas
		return
		
	for pistol in get_parent().get_parent().num_pistolas:
		if get_tree().get_nodes_in_group("pistola")[pistol].tipe_pistoll == 1:
			if interruptor_stado:
				get_tree().get_nodes_in_group("pistola")[pistol].estado_pistola = true
			elif !interruptor_stado:
				get_tree().get_nodes_in_group("pistola")[pistol].estado_pistola = false
	

extends KinematicBody2D
#VALORES DESPLAZAMIENTO 
export var speed_force = 200
export var vel_salto = 300
export var gravedad = 400

#PARAMETROS DESPLAZAMIENTO
var distance = Vector2()
var speed = Vector2()
var direction_x = 0

#LIMITACIONES

var movement_enable = false

#PARAMETROS DINAMICOS
export var num_copy = 0

#ESTADOS_CHARACTER
enum states_player {flat, jump, shovel, death}
var virus_state = states_player

var raycast_back = false # Parametro conectado a raycast inferior para detectar suelo


func _ready():
#	$Sprite.visible = true
	$Label.text = str(num_copy)
	actionPlayer('action_spawn')
	yield ($anim_player, "animation_finished")
	virus_state = states_player.jump # Nace en el aire por que estando en el aire se activan sus coliciones
	movement_enable = true

	
func _physics_process(delta):
	if movement_enable: move(delta)

func cont_copias(operation_type, num): #Numero de copias del virus
	match operation_type:
		'addition': num_copy += num
		'subtraction': num_copy -= num
	$Label.text = str(num_copy)


func move(delta):
	direction_x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	
	distance.x = speed_force * delta
	speed.x = (direction_x * distance.x)/delta
	speed.y += gravedad * delta
	move_and_slide(speed, Vector2(0,-1))
	
	if is_on_floor():
		speed.y = 0
		virus_state = states_player.flat
		if !$Raycast.active: $Raycast.active = true #Activador de funcionamiento nodo raycast para desplazar uniddad en el eje x
		if raycast_back: coll_alteracion('collSquare') # Si la colicion circular esta activada la desactivamos y activamos la colicion cuadrada
		
		if direction_x != 0:
			match direction_x:
				-1: $Sprite.flip_h = true
				1: $Sprite.flip_h = false
			if is_on_wall(): actionPlayer('action_idle') #Animacion detenida si coliciona con una pared
			else: actionPlayer('action_move')
			
		else: $anim_player.play("idle")
	
		if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("espacio"):
			actionPlayer('action_jump')
			virus_state = states_player.jump
			coll_alteracion('collCircle')
			$timer_fig_coll.start()
			speed.y = -vel_salto
			
#	elif !raycast_back:
#		if !is_on_floor() and speed.y != 0: coll_alteracion('collCircle')
#		else: $anim_player.play("walk")
		
		
func muerte(tipo_muerte: String):
	if virus_state != states_player.death:
		movement_enable = false
		virus_state = states_player.death
		
		match tipo_muerte:
			'pistola': #Pistola
				coll_alteracion('collDisabled') # Desactivar colicion
				actionPlayer('death_gun')
				yield($anim_player, "animation_finished")
				#yield(get_tree().create_timer(4.0),"timeout")
				queue_free()
			'pincho': #Pincho
				coll_alteracion('collSquare') # Cambiamos colicion a cuadrada
				actionPlayer('death_spike')
				yield($anim_player, "animation_finished")
				#OJO - Aqui va a a ver un bug si hay mas de un enpalado, y muere el ultimo activo el juego se quedara congelado.
		GameHundler.game_over()
	
# Simulando un bug?? xD
#func bug(): 
#		$anim_player.play("jump")
##		yield($anim_player,"animation_finished")
#		yield(get_tree().create_timer(0.1),"timeout")
#		$coll_square.disabled = true
#		yield(get_tree().create_timer(0.2),"timeout")
#		movement_enable = false
#		$anim_player.play("bug")
#		get_parent().escenas(1)


func _on_VisibilityNotifier2D_screen_exited():
	yield(get_tree().create_timer(0.01),"timeout")
	$coll_square.disabled = false
	get_parent().get_node("Camera2D").current = false #Desactivamos la camara del nivel
	$Camera2D.current = true


func coll_alteracion(tipe_coll: String):
	match tipe_coll:
		'collSquare': # Activar colicion cuadrada
			$coll_square.set_shape(RectangleShape2D.new())
			$coll_square.shape.extents = Vector2(28, 28)
		'collCircle': # Activar colicion circular
			if virus_state == states_player.jump:
				$coll_square.set_shape(CircleShape2D.new())
				$coll_square.shape.radius = 28
		'CollDisabled':
			$coll_square.disabled = true


#Funcion para desplazar al jugador de izquierda a derecha en los saltos
func movPosition(direction):
	if direction: global_position -= Vector2(-1.5,0)
	elif !direction: global_position -= Vector2(+1.5,0)


func null_salto():
	speed.y = 40


func actionPlayer(anim_type: String):
	match anim_type:
		'action_spawn':
			$anim_player.play("spawn")
		'action_jump':
			$anim_player.play("jump")
			$SFX/salto.play()
		'action_idle':
			$anim_player.play("idle")
		'action_move':
			$anim_player.play("move")
		'death_gun':
			$coll_square.disabled = true
			$anim_player.play("death") #Animacion de emuerte por vala
			$SFX/muerte.play() # Explocion de virusito por vala
		'death_spike':
			$anim_player.play("congelado") #Animacion de emuerte por pincho enpalado xD
			$SFX/muerte.play()  # Sonido muerte por enpalamiento

# Cuando termine el tiempo del timer
func _on_Timer_timeout():
	if(speed.y > 1500):
		global_position.y += -5
		coll_alteracion('collSquare')

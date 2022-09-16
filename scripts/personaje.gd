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
var velocidad_y_tope = 0 # Variable para reconocer caida del personaje
var movement_enable = false
var live_virus = true

#PARAMETROS DINAMICOS
export var num_copy = 0

#ESTADOS_CHARACTER
enum states_player {flat, jump, freeze}
var virus_state = states_player

var raycast_back = false # Parametro conectado a raycast inferior para detectar suelo


func _ready():
	$Label.text = str(num_copy)
	AnimationPlayer('spawn')
	yield ($anim_player, "animation_finished")
	virus_state = states_player.jump # Nace en el aire por que estando en el aire se activan sus coliciones
	movement_enable = true

	
func _physics_process(delta): if movement_enable: move(delta)
	

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
		velocidad_y_tope = 0
		virus_state = states_player.flat
		if !$Raycast.active: $Raycast.active = true #Activador de funcionamiento nodo raycast para desplazar uniddad en el eje x
		if raycast_back: coll_alteracion(0) # Si la colicion circular esta activada la desactivamos y activamos la colicion cuadrada
		
		if direction_x != 0:
			match direction_x:
				-1: $Sprite.flip_h = true
				1: $Sprite.flip_h = false
			if is_on_wall(): $anim_player.play("idle") #Animacion detenida si coliciona con una pared
			else: $anim_player.play("move")
			
		else: $anim_player.play("idle")
	
		if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("espacio"):
			$anim_player.play("jump")
			$SFX/salto.play()
			virus_state = states_player.jump
			speed.y = -vel_salto
			
	elif !raycast_back:
		if !is_on_floor(): coll_alteracion(1)
		else: $anim_player.play("walk")
		
		
func muerte(tipo_muerte):
	if live_virus:
		live_virus = false
		movement_enable = false
		coll_alteracion(2) # Desactivar colicion
		match tipo_muerte:
			0: #Pistola
				$anim_player.play("congelado")
				yield(get_tree().create_timer(4.0),"timeout")
		$coll_square.disabled = true
		$anim_player.play("death")
		$SFX/muerte.play()
		yield($anim_player, "animation_finished")
		GameHundler.game_over()
		queue_free()
	

func bug(): # Simulando un bug?? xD
		$anim_player.play("jump")
#		yield($anim_player,"animation_finished")
		yield(get_tree().create_timer(0.1),"timeout")
		$coll_square.disabled = true
		yield(get_tree().create_timer(0.2),"timeout")
		movement_enable = false
		$anim_player.play("bug")
		get_parent().escenas(1)#Reproducir escena de final dos


func _on_VisibilityNotifier2D_screen_exited():
	yield(get_tree().create_timer(0.01),"timeout")
	$coll_square.disabled = false
	get_parent().get_node("Camera2D").current = false #Desactivamos la camara del nivel
	$Camera2D.current = true


func coll_alteracion(tipe_coll):
	match tipe_coll:
		0: # Activar colicion cuadrada
			$coll_square.set_shape(RectangleShape2D.new())
			$coll_square.shape.extents = Vector2(28, 28)
		1: # Activar colicion circular
			if  virus_state == states_player.jump:
				$coll_square.set_shape(CircleShape2D.new())
				$coll_square.shape.radius = 28
		2:
			$coll_square.disabled = true

#Funcion para desplazar al jugador de izquierda a derecha en los saltos
func movPosition(direction):
	if direction: global_position -= Vector2(-1.5,0)
	elif !direction: global_position -= Vector2(+1.5,0)


func null_salto():
	speed.y = 40
	velocidad_y_tope = 0
	

func AnimationPlayer(anim_type):
	match anim_type:
		'spawn': $anim_player.play("spawn")
		

extends Sprite

export var position_ball = 0 # 0=izquierda, 1=derecha, 2=arriba, 3=abajo
export var id_pistola = 0 # Identificar a que grupo por id pertenece
export var tipe_pistoll = 0 # 0=pistolRasho, 1=pistolServer

export (Texture) var pistola_uno # pistolRasho
export (Texture) var pistola_dos # pistolServer

var timeSpawn_ball = 0 # Tiempo de espera para la generacion de la siguiente vala
var velocityBall = 0 # velocidad de desplazamiento de la vala

var distancia_disparo = 15

var estado_pistola = false
var ball_cola = true
var bala = load("res://scenas/bala.tscn") # cargamos la bala


func _ready():
	# Ubicacion de punto de disparo
	match position_ball:
		0: 
			$Position2D.position = Vector2(-distancia_disparo,0)
			frame = 3
			flip_h = true
		1: 
			$Position2D.position = Vector2(distancia_disparo,0)
			frame = 3
			flip_h = false
		2: 
			$Position2D.position = Vector2(0,-distancia_disparo)
			frame = 0
			flip_v = true
		3: 
			$Position2D.position = Vector2(0,distancia_disparo)
			frame = 0
			flip_v = false
	
	match tipe_pistoll:
		0: 
			texture = pistola_uno
			timeSpawn_ball = 0.2
			velocityBall = 160
		1:
			texture = pistola_dos
			timeSpawn_ball = 1
			velocityBall = 40

func _physics_process(delta):
	if estado_pistola and ball_cola:
		disparar()
		match position_ball:
			0: $anim_pist.play("disparo_x")
			1: $anim_pist.play("disparo_x")
			2: $anim_pist.play("disparo_y")
			3: $anim_pist.play("disparo_y")
	elif !estado_pistola:
		match position_ball:
			0: $anim_pist.play("idle_x")
			1: $anim_pist.play("idle_x")
			2: $anim_pist.play("idle_y")
			3: $anim_pist.play("idle_y")

func disparar(): # Instanciar bala
	$SFX/rasho.play()
	var newbala = bala.instance()
	get_parent().add_child(newbala)
	newbala.global_position = $Position2D.global_position
	newbala.direccion = position_ball
	newbala.velocidad = velocityBall
	#Pausamos la generacion de la bala por un periodo de tiempo
	ball_cola = false
	yield(get_tree().create_timer(timeSpawn_ball), "timeout")
	ball_cola = true

	

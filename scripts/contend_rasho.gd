extends Node2D

export var id_rasho = 0

enum modoRasho {activo, apagado, alerta}
var estado_laser = modoRasho

var active_rasho = true # Eliminar o no eleiminar intrusos

func _ready():
	estado_laser = modoRasho.activo
	$punto_a/anim_estado.play("activo")
	$rasho_laser/anim.play("move")

func _on_area_rasho_body_entered(body):
	if body.is_in_group("personaje") and estado_laser != modoRasho.apagado: _alerta()
	
func _on_area_rasho_body_exited(body):
	if body.is_in_group("personaje") and estado_laser == modoRasho.alerta:
#		yield(get_tree().create_timer(0.6), "timeout")
		_activo()

func _apagado():
	estado_laser = modoRasho.apagado
	if $rasho_laser.visible: $rasho_laser.visible = false
#	$SFX/apagado.play()
	$punto_a/anim_estado.play("apagado")
	for i in get_parent().get_parent().num_pistolas:
		if get_tree().get_nodes_in_group("pistola")[i].id_pistola == id_rasho:
			get_tree().get_nodes_in_group("pistola")[i].estado_pistola = false
			
func _activo():
	estado_laser = modoRasho.activo
	if !$rasho_laser.visible: $rasho_laser.visible = true
	$punto_a/anim_estado.play("activo")
	for i in get_parent().get_parent().num_pistolas:
		if get_tree().get_nodes_in_group("pistola")[i].id_pistola == id_rasho:
			get_tree().get_nodes_in_group("pistola")[i].estado_pistola = false

func _alerta():
	estado_laser = modoRasho.alerta
	$punto_a/anim_estado.play("alerta")
	for i in get_parent().get_parent().num_pistolas:
		if get_tree().get_nodes_in_group("pistola")[i].id_pistola == id_rasho: #Identifica si es la pistola perteneciente
			get_tree().get_nodes_in_group("pistola")[i].estado_pistola = true # Si es la pistola, la activa
	yield($punto_a/anim_estado,"animation_finished")
	$punto_a/anim_estado.play("alerta_dos")

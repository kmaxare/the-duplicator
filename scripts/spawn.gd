extends Position2D

export (PackedScene) var personaje

var new_pers
export var spawn_name = 0

var personaje_dos = load("res://scenas/personaje.tscn") # cargamos la personaje

func _ready():
	$anim_spawn.play("inactibe")

#func generador(tipo):
#	if tipo == spawn_name:
#		new_pers = personaje.instance()
#		get_tree().get_nodes_in_group("escena")[0].add_child(new_pers)
#		new_pers.global_position = global_position

func generador(tipo):
	if tipo == spawn_name:
		$anim_spawn.play("explosion")
		new_pers = personaje_dos.instance()
		get_tree().get_nodes_in_group("escena")[0].add_child(new_pers)
		new_pers.global_position = global_position
		get_parent().get_parent().get_node("SFX/spaw_player").play()
		yield($anim_spawn,"animation_finished")
		$anim_spawn.play("inactibe")

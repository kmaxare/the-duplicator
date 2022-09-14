extends Area2D

var use_active = true
var disable = false;

#0 Folder - 1 Disco - 2 escondido
export var tipe_end = 0

export (Texture) var folder
export (Texture) var disco

func _ready():
	$anim_end.play("idle")
	ajustes_frame()

func _on_end_body_entered(body):
#	$CollisionShape2D.disabled = true # Desavilitamos esta colicion
#	get_parent().desac_coll() # Desavilitamos colicion de puertos
#	get_tree().get_nodes_in_group("game")[0].level_end() # Cargamos siguiente nivel
	if body.is_in_group("personaje") and use_active:
		GameHundler.nivel_act += 1
		get_tree().change_scene("res://Game.tscn")
		use_active = false
	elif body.is_in_group("bala"): suprimir_carpeta()

func ajustes_frame():
	match tipe_end:
		0:
			$Sprite.texture = folder
			$Sprite.vframes = 2
			$Sprite.hframes = 2
		1:
			$Sprite.texture = disco
			$Sprite.vframes = 3
			$Sprite.hframes = 3
		2:
			$Sprite.texture = folder
			$Sprite.vframes = 2
			$Sprite.hframes = 2
			$anim_end.play("invi")
			visible = false
			$CollisionShape2D.disabled = true
	
func suprimir_carpeta():
	$CollisionShape2D.disabled = true
	queue_free()

func mostrar_carpetas():
	#Animacion de carpetas activas
	visible = true
	$CollisionShape2D.disabled = false

extends Area2D

export var tipe_point = 0
export var time_respawn = 4
export var tope_spawn = 10

export var point = 1
var boot_activo = true

export (Texture) var folder
export (Texture) var archivo

func _ready():
	match tipe_point:
		0: $Sprite.texture = folder
		1: $Sprite.texture = archivo
	$anim_npc.play("dance")

func _on_point_body_entered(body):
	if body.is_in_group("personaje") and boot_activo:
		body.cont_copias('addition', point) # Sumamos mas uno al personaje
		$SFX/comer.play()
		disable()
		
func disable():
	visible = false
	boot_activo = false
	#anim desaparecer
	yield(get_tree().create_timer(time_respawn), "timeout")
	if tipe_point == 1 or tope_spawn == 1: queue_free()
	#anim activar
	tope_spawn -= 1
	boot_activo = true
	visible = true

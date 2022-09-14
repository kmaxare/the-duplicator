extends Area2D

export var type_pua = 0

func _ready():
	pass


func _on_puas_body_entered(body):
	if body.is_in_group("personaje"):
		body.muerte(1)

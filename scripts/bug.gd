extends Area2D

func _ready():
	pass


func _on_bug_body_entered(body):
	if body.is_in_group("personaje"): body.bug()
	queue_free()
		
#func _on_bug_body_exited(body):
#	if body.is_in_group("personaje"): body.bug()

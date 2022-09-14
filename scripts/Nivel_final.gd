extends Control

func _ready():
	$Sprite/AnimationPlayer.play("rapido")

func _process(delta):
	if Input.is_action_just_pressed("main"):
		GameHundler.nivel_act = 1
		get_tree().change_scene("res://scenas/Main.tscn")

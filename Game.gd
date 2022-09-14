extends Node2D

export (PackedScene) var nivel_uno
export (PackedScene) var nivel_dos
export (PackedScene) var nivel_tres

var nivel # Recipiente nivel

func _ready():
	GameHundler.cargar_nivel()

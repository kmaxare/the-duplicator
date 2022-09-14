extends Control

var text_one = 'Pero todo sacrificio tiene su recompensa! es hora de que termines el trabajo para que fuiste creado.'
var text_two = '¡Hey!...'
var text_three = 'Esto no debió haber pasado, no trates de saltar o arruinaras el juego, solo presiona R para reiniciar el nivel.'

var text_pullApart = []

var texto = ''

func _ready():
	pass

func _process(delta):
#	$Label.rect_size = Vector2(158,123)
	pass
	
func _text(value):
	yield(get_tree().create_timer(2),"timeout")
	var x_text
	match value:
		0: x_text = text_one
		1: x_text = text_two
		2: 
			x_text = text_three
			yield(get_tree().create_timer(2.5),"timeout")
		
	for caracter in x_text:
		text_pullApart.append(caracter)
	for valor in range(len(text_pullApart)):
		texto += text_pullApart[valor]
		$Label.text = str(texto)
		yield(get_tree().create_timer(0.05),"timeout")
	if x_text == text_three: get_parent().bloqueo = false
	text_pullApart = []
	texto = ''

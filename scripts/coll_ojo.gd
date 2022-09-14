extends StaticBody2D

var vida = 0;
var num_puertas= 0;

func _ready():
	$ojo_cont.text = '0'
	if get_tree().get_nodes_in_group("puerta")[0]:
		num_puertas = get_tree().get_nodes_in_group("puerta").size()

func romper_ojo():
	vida += 1
	if vida == 6:
		active_port()
		queue_free()
	$ojo_cont.text = str(vida)


func _on_Timer_timeout():
	if vida > 0:
		vida -= 1
		$ojo_cont.text = str(vida)
		
func active_port():
	for i in num_puertas:
		if  get_tree().get_nodes_in_group("puerta")[i].tipe_end == 2:
			get_tree().get_nodes_in_group("puerta")[i].mostrar_carpetas()
		

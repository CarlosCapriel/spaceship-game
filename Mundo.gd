extends Node
export (PackedScene) var Roca

var Score
var flag_game_over = false

func _ready():
	randomize()
	$MusicMenu.play()
	


func nuevo_juego():
	$MusicMenu.stop()
	Score = 0
	$Player.inicio($PosicionInicio.position) # Posicion de inicio obtenido desde el nodo PosicionInicio
	$InicioTimer.start()
	$Interfaz.mostrar_mensaje("Listo!")
	$Interfaz.update_score(Score)
	$Musica.play()
	flag_game_over = false


func game_over():
	$ScoreTimer.stop()
	$RocaTimer.stop()
	$Interfaz.game_over()
	$AudioGameOver.play()
	$Musica.stop()
	if !flag_game_over:
		flag_game_over = true
		$MusicMenu.play()

func _on_InicioTimer_timeout():
	$RocaTimer.start()
	$ScoreTimer.start()	


func _on_ScoreTimer_timeout():
	Score += 1
	$Interfaz.update_score(Score)

func _on_RocaTimer_timeout():
	#Selecciona un lugar aleatorio en el path donde se creará la roca
	$Camino/RocaPosicion.set_offset(randi())
	var R = Roca.instance()
	add_child(R)
	# Selecciona una dirección
	var dir_roca = $Camino/RocaPosicion.rotation + PI / 2
	#Establece la posicion de la nueva roca creada
	R.position = $Camino/RocaPosicion.position
	
	dir_roca += rand_range(-PI/4, PI/4) # funciona con radianas
	R.rotation = dir_roca
	R.set_linear_velocity(Vector2(rand_range(R.velocidad_min, R.velocidad_max), 0).rotated(dir_roca))
	 

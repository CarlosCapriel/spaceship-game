extends Area2D
# La siguiente linea, hace que la varible Velocidad aparezca en la pestaña inspector
export (int) var Velocidad  #Velocidad en la que se mueve el personaje

var Movimiento = Vector2() # Posicionamiento
var limite
signal golpe

# Called when the node enters the scene tree for the first time.
func _ready():
	hide() # oculta el personaje
	limite = get_viewport_rect().size # obtiene el tamaño de la ventana


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Movimiento = Vector2() # Reiniciar el valor
	if Input.is_action_pressed("ui_right"):
		Movimiento.x += 1
	if Input.is_action_pressed("ui_left"):
		Movimiento.x -= 1
	if Input.is_action_pressed("ui_up"):
		Movimiento.y -= 1
	if Input.is_action_pressed("ui_down"):
		Movimiento.y += 1
	if Movimiento.length() > 0: # Verica si se está moviendo 
		Movimiento = Movimiento.normalized() * Velocidad # para normalizar la velocidad
	
	position += Movimiento * delta # actualiza los movimientos
	position.x = clamp(position.x, 0, limite.x)
	position.y = clamp(position.y, 0, limite.y)
	
	if Movimiento.x != 0: # Cambia el sprite(lo estas moviendo a los lados)
		$Sprite_player.animation = "lado" # Cambiamos el nombre de la animación
		$Sprite_player.flip_h = Movimiento.x < 0 #Invertir el sprite de acuerdo a un valor booleano, en vertical
					# Moviento si es menor a 0 se esta moviendo a la izquierda, se invierte el sprite
		$Sprite_player.flip_v = false
	elif Movimiento.y != 0: #Cambia sprite(se esta moviendo en vertical)
		$Sprite_player.animation = "espalda"
		$Sprite_player.flip_v = Movimiento.y > 0
	else: # Personaje esta parado
		$Sprite_player.animation = "frente"

# posible la forma en que esta escrita el nombre del nodo Colission,antes la c estaba minuscula
func _on_Player_body_entered(body): #Cuando haya una colisión con el cuerpo
	hide()
	emit_signal("golpe")
	$CollisionShape2D.disabled = true

func inicio(pos):
	position = pos
	show() # mostrar el personaje
	$CollisionShape2D.disabled = false

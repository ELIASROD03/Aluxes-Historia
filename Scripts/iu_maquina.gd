extends Node2D

# El año objetivo se definirá automáticamente según el progreso del jugador
var anio_objetivo: String = "1519"
var escena_destino: String = ""

# Referencias a los 4 Labels (asignalos desde el Inspector)
@export var labels: Array[Label]

# Variables para guardar el número de cada casilla
var digitos: Array[int] = [0, 0, 0, 0]

# Referencia al botón confirmar (asígnalo desde el Inspector)
@export var boton_confirmar: Button

func _ready():
	# Determinar el año y el nivel destino dependiendo del progreso de la historia
	match Global.progreso_historia:
		1:
			anio_objetivo = "1519" # O el año que necesites para Tenochtitlán
			escena_destino = "res://Scenes/Tenoch.tscn"
		2:
			anio_objetivo = "1810"
			escena_destino = "res://Scenes/Independencia.tscn" # Ejemplo
		_:
			anio_objetivo = "0000"
			escena_destino = "res://Scenes/MenuPrincipal.tscn"

	if has_node("/root/Global"):
		get_node("/root/Global").set("anio_objetivo_actual", anio_objetivo)

	# Inicializar la interfaz con ceros
	actualizar_labels()
	
	# Conectar el botón de confirmar por código (si lo asignaste en el inspector)
	if boton_confirmar:
		boton_confirmar.pressed.connect(_on_confirmar_pressed)

# ---------------------------------------------
# Funciones para cambiar los dígitos
# Conecta la señal 'pressed' de tus TextureButtons a estas funciones
# ---------------------------------------------

func cambiar_digito(indice: int, cantidad: int):
	digitos[indice] += cantidad
	
	# Dar la vuelta si pasa de 9 o baja de 0
	if digitos[indice] > 9:
		digitos[indice] = 0
	elif digitos[indice] < 0:
		digitos[indice] = 9
		
	actualizar_labels()

func actualizar_labels():
	# Actualiza el texto de los 4 labels
	for i in range(labels.size()):
		if labels[i]:
			labels[i].text = str(digitos[i])

# --- Casilla 1 ---
func _on_arriba_1_pressed():
	cambiar_digito(0, 1)

func _on_abajo_1_pressed():
	cambiar_digito(0, -1)

# --- Casilla 2 ---
func _on_arriba_2_pressed():
	cambiar_digito(1, 1)

func _on_abajo_2_pressed():
	cambiar_digito(1, -1)

# --- Casilla 3 ---
func _on_arriba_3_pressed():
	cambiar_digito(2, 1)

func _on_abajo_3_pressed():
	cambiar_digito(2, -1)

# --- Casilla 4 ---
func _on_arriba_4_pressed():
	cambiar_digito(3, 1)

func _on_abajo_4_pressed():
	cambiar_digito(3, -1)


# ---------------------------------------------
# Validación del Viaje
# ---------------------------------------------
func _on_confirmar_pressed():
	# Unimos los 4 dígitos en un solo texto (ej. "1" + "5" + "1" + "2" -> "1512")
	var anio_ingresado = str(digitos[0]) + str(digitos[1]) + str(digitos[2]) + str(digitos[3])
	
	if anio_ingresado == anio_objetivo:
		print("¡Código Correcto! Viajando al año: ", anio_objetivo)
		# Cambiamos a la escena destino (el nivel que toca jugar)
		get_tree().change_scene_to_file(escena_destino)
	else:
		print("Código Incorrecto. Has puesto: ", anio_ingresado)
		# Mostrar el cuadro de diálogo con el mensaje dinámico
		var cuadro = get_node_or_null("CuadroDialogo")
		if cuadro and cuadro.has_method("iniciar_dialogo") and not cuadro.visible:
			cuadro.iniciar_dialogo("error_maquina")

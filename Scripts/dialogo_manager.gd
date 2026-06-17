class_name DialogoManager
extends Node2D

signal dialogo_terminado(id_dialogo)

# Asegúrate de asignar estas referencias en el editor, o cambia las rutas si tus nodos se llaman distinto
@export var texto_label: Control # Cambiado a Control para que acepte tanto Label como RichTextLabel
@export var nombre_label: Label
@export var retrato_sprite: Node

var archivo_dialogos = "res://dialogos.json"
var dialogos_cargados = {}
var dialogo_actual: Array = []
var indice_dialogo = 0
var id_dialogo_actual: String = ""
var tiempo_ultimo_avance: float = 0.0

func _process(delta: float) -> void:
	if visible:
		tiempo_ultimo_avance += delta

func debug_log(msg: String):
	var f = FileAccess.open("user://debug_log.txt", FileAccess.READ_WRITE)
	if not f:
		f = FileAccess.open("user://debug_log.txt", FileAccess.WRITE)
	f.seek_end()
	f.store_line(msg)
	f.close()
	print(msg)

func _ready():
	hide() # Ocultar por defecto
	_cargar_dialogos()

func _cargar_dialogos():
	if FileAccess.file_exists(archivo_dialogos):
		var file = FileAccess.open(archivo_dialogos, FileAccess.READ)
		var contenido = file.get_as_text()
		var json = JSON.new()
		var error = json.parse(contenido)
		if error == OK:
			dialogos_cargados = json.data
		else:
			print("Error leyendo diálogos.")

func iniciar_dialogo(id_dialogo: String):
	debug_log("Iniciando dialogo: " + id_dialogo)
	id_dialogo_actual = id_dialogo
	if dialogos_cargados.has(id_dialogo):
		dialogo_actual = dialogos_cargados[id_dialogo]
		indice_dialogo = 0
		show()
		if has_node("/root/Global"):
			var GlobalNode = get_node("/root/Global")
			GlobalNode.en_dialogo = true
			debug_log("Seteado Global en_dialogo a true")
		else:
			debug_log("No se encontro /root/Global en iniciar_dialogo")
		_mostrar_linea_actual()
	else:
		debug_log("No existe el diálogo: " + id_dialogo)

func _mostrar_linea_actual():
	if indice_dialogo < dialogo_actual.size():
		var linea = dialogo_actual[indice_dialogo]
		
		var texto = linea.get("texto", "")
		var personaje_nombre = linea.get("personaje", "")
		
		# Reemplazar variables dinámicas
		if has_node("/root/Global"):
			var global_node = get_node("/root/Global")
			var nombre_jugador = global_node.get("nombre_jugador")
			var anio_objetivo = global_node.get("anio_objetivo_actual")
			
			if typeof(nombre_jugador) == TYPE_STRING:
				texto = texto.replace("{nombre_jugador}", nombre_jugador)
				personaje_nombre = personaje_nombre.replace("{nombre_jugador}", nombre_jugador)
			
			if typeof(anio_objetivo) == TYPE_STRING:
				texto = texto.replace("{anio_objetivo}", anio_objetivo)
		
		if texto_label: 
			texto_label.text = texto
		if nombre_label: 
			nombre_label.text = personaje_nombre
		
		var ruta_img = linea.get("imagen", "")
		# Eliminamos la sobreescritura automática para que respete lo que pusiste en el JSON
			
		if retrato_sprite:
			if ruta_img != "" and ResourceLoader.exists(ruta_img):
				retrato_sprite.texture = load(ruta_img)
			else:
				retrato_sprite.texture = null
	else:
		# Fin del diálogo
		hide()
		if has_node("/root/Global"):
			var GlobalNode = get_node("/root/Global")
			GlobalNode.en_dialogo = false
		dialogo_terminado.emit(id_dialogo_actual)

func _input(event):
	# Al presionar Enter, cliquear, o tocar la pantalla en móvil, avanzar
	if visible and (event.is_action_pressed("ui_accept") or (event is InputEventMouseButton and event.pressed) or (event is InputEventScreenTouch and event.pressed)):
		if tiempo_ultimo_avance > 0.1:
			avanzar_dialogo()
			tiempo_ultimo_avance = 0.0

func avanzar_dialogo():
	var linea_actual = dialogo_actual[indice_dialogo]
	if linea_actual.has("evento"):
		var evento = linea_actual["evento"]
		if evento.begins_with("minijuego_palabras_"):
			hide()
			var escena = load("res://Scenes/PalabrasImpostoras.tscn").instantiate()
			escena.nivel_a_cargar = evento.replace("minijuego_palabras_", "")
			escena.connect("juego_completado", Callable(self, "_on_minijuego_terminado").bind(escena))
			
			var canvas = CanvasLayer.new() # Añadir a un canvas layer para que quede encima
			canvas.layer = 100
			canvas.add_child(escena)
			get_tree().current_scene.add_child(canvas)
			
			indice_dialogo += 1
			return
			
	indice_dialogo += 1
	_mostrar_linea_actual()

func _on_minijuego_terminado(escena_instancia):
	if escena_instancia:
		var canvas = escena_instancia.get_parent()
		escena_instancia.queue_free()
		if canvas is CanvasLayer:
			canvas.queue_free()
	show()
	_mostrar_linea_actual()

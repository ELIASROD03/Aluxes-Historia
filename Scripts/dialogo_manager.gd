class_name DialogoManager
extends Node2D

# Asegúrate de asignar estas referencias en el editor, o cambia las rutas si tus nodos se llaman distinto
@export var texto_label: Control # Cambiado a Control para que acepte tanto Label como RichTextLabel
@export var nombre_label: Label
@export var retrato_sprite: Node

var archivo_dialogos = "res://dialogos.json"
var dialogos_cargados = {}
var dialogo_actual: Array = []
var indice_dialogo = 0

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
		
		if texto_label: 
			texto_label.text = linea.get("texto", "")
		if nombre_label: nombre_label.text = linea.get("personaje", "")
		
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

func _input(event):
	# Al presionar Enter o la barra espaciadora, avanzar
	if visible and (event.is_action_pressed("ui_accept") or (event is InputEventMouseButton and event.pressed)):
		avanzar_dialogo()

func avanzar_dialogo():
	indice_dialogo += 1
	_mostrar_linea_actual()

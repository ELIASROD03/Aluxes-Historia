extends Control

@onready var nombre_input = $PanelOpciones/VBoxContainer/HBoxNombre/LineEdit
@onready var sprite_animado = $PanelVistaPrevia/HBoxSeleccion/AvatarContainer/AnimatedSprite2D
@onready var btn_izq = $PanelVistaPrevia/HBoxSeleccion/BtnIzq
@onready var btn_der = $PanelVistaPrevia/HBoxSeleccion/BtnDer

# Lista de personajes disponibles (ahora solo tenemos 1, pero listo para agregar más)
var personajes = [
	{
		"id": "Personaje1",
		"ruta_spritesheet": "res://Images/Personajes/Personajes_Principales/Personaje1/respirando/untitled(7).png",
		"ruta_walk": "res://Images/Personajes/Personajes_Principales/Personaje1/walk.png"
	},
	{
		"id": "Personaje2",
		"ruta_spritesheet": "res://Images/Personajes/Personajes_Principales/Personaje2/respirando/untitled(7).png",
		"ruta_walk": ""
	}
]
var indice_personaje_actual = 0

func _ready() -> void:
	if btn_izq: btn_izq.pressed.connect(_on_btn_izq_pressed)
	if btn_der: btn_der.pressed.connect(_on_btn_der_pressed)
	
	_cargar_personaje_actual()

func _cargar_personaje_actual() -> void:
	if not sprite_animado: return
	
	var pers = personajes[indice_personaje_actual]
	var frames = SpriteFrames.new()
	frames.add_animation("respirando")
	frames.set_animation_loop("respirando", true)
	frames.set_animation_speed("respirando", 8.0)
	
	var ruta = pers["ruta_spritesheet"]
	if ResourceLoader.exists(ruta):
		var tex = load(ruta)
		var num_frames = 9
		var frame_width = tex.get_width() / num_frames
		var frame_height = tex.get_height()
		for i in range(num_frames):
			var atlas = AtlasTexture.new()
			atlas.atlas = tex
			atlas.region = Rect2(i * frame_width, 0, frame_width, frame_height)
			frames.add_frame("respirando", atlas)
	else:
		var tex = load("res://Images/Tilesets/south.png")
		if tex:
			frames.add_frame("respirando", tex)
	
	sprite_animado.sprite_frames = frames
	sprite_animado.play("respirando")

func _on_btn_izq_pressed() -> void:
	indice_personaje_actual -= 1
	if indice_personaje_actual < 0:
		indice_personaje_actual = personajes.size() - 1
	_cargar_personaje_actual()

func _on_btn_der_pressed() -> void:
	indice_personaje_actual += 1
	if indice_personaje_actual >= personajes.size():
		indice_personaje_actual = 0
	_cargar_personaje_actual()

func _on_guardar_btn_pressed() -> void:
	var nombre_ingresado = nombre_input.text.strip_edges() if nombre_input else ""
	if nombre_ingresado == "":
		var alert = AcceptDialog.new()
		alert.title = "Atención"
		alert.dialog_text = "Debes ingresar un nombre\npara comenzar tu aventura."
		
		# Cambiamos el tamaño de la letra del mensaje interno a 12
		var label = alert.get_label()
		if label:
			label.add_theme_font_size_override("font_size", 12)
			
		add_child(alert)
		alert.popup_centered(Vector2i(200, 100))
		return
		
	var datos_personaje = {
		"nombre": nombre_ingresado,
		"personaje_id": personajes[indice_personaje_actual]["id"]
	}
	
	if has_node("/root/Global"):
		var Global = get_node("/root/Global")
		Global.nombre_jugador = nombre_ingresado
		Global.personaje_seleccionado = personajes[indice_personaje_actual]["id"]
		Global.ruta_spritesheet = personajes[indice_personaje_actual]["ruta_spritesheet"]
		Global.ruta_walk = personajes[indice_personaje_actual].get("ruta_walk", "")
		
	print("Personaje seleccionado: ", datos_personaje)
	SceneTransition.change_scene("res://Scenes/Capitulo1Intro.tscn")

func _on_volver_btn_pressed() -> void:
	SceneTransition.change_scene("res://Scenes/MenuPrincipal.tscn")

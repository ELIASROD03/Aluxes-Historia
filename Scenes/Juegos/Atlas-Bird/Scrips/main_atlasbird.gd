extends Node2D

@export var pipe_scene : PackedScene

# Rutas y constantes
const NEXT_SCENE = "res://Scenes/MenuPrincipal.tscn"

# Referencias a UI
@onready var tap_imagen = $Tap
@onready var presionar_imagen = $Presionar
@onready var label_puntos = $LabelPuntos
@onready var ganaste_ui = $GanasteImagen
@onready var boton_menu = $Button

# Variables de dificultad y estado
@export var velocidad_inicial: float = 200.0
var velocidad_actual: float = 200.0
@export var incremento_velocidad: float = 20.0

var puntos: int = 0
var game_active: bool = false

# Referencias a nodos de juego
@onready var bird = $atlas
@onready var pipe_timer: Timer = $pipetimer

func _ready() -> void:
	add_to_group("mundo")
	await get_tree().process_frame
	
	# Configuración inicial
	velocidad_actual = velocidad_inicial
	if ganaste_ui: ganaste_ui.hide()
	if boton_menu: boton_menu.hide()
	
	if bird:
		bird.bird_died.connect(_on_bird_died)
	
	pipe_timer.wait_time = 2.0
	pipe_timer.timeout.connect(_spawn_pipe)
	if boton_menu:
		if not boton_menu.pressed.is_connected(_on_boton_menu_pressed):
			boton_menu.pressed.connect(_on_boton_menu_pressed)

func _input(event: InputEvent) -> void:
	var is_tap = (event is InputEventMouseButton and event.pressed) or \
				 (event is InputEventScreenTouch and event.pressed) or \
				 event.is_action_pressed("ui_accept")
	
	if not is_tap:
		return
	
	# Si el pájaro está muerto o ya ganamos, no hacemos nada
	if bird.is_dead:
		return
		
	# INICIAR EL JUEGO AL PRIMER CLIC
	if not game_active:
		tap_imagen.hide()        # OCULTA EL DEDO
		presionar_imagen.hide()  # OCULTA EL TEXTO DE INICIO
		_start_game()
	
	bird.jump()

func _start_game() -> void:
	game_active = true
	pipe_timer.start()
	print("Juego iniciado")

func añadir_punto() -> void:
	if game_active:
		puntos += 1
		label_puntos.text = str(puntos)
		
		# 1. Aumentamos la variable global
		velocidad_actual += incremento_velocidad
		
		# 2. ¡ESTA ES LA CLAVE!: Avisamos a todos los tubos que ya están volando
		get_tree().call_group("tuberias", "set_speed", velocidad_actual)
		
		# Reducimos el tiempo de espera del timer
		if pipe_timer.wait_time > 0.9:
			pipe_timer.wait_time -= 0.05
			
		if puntos >= 10:
			_victoria()

func _victoria() -> void:
	game_active = false
	pipe_timer.stop()
	bird.is_dead = true # Detiene el control del pájaro
	ganaste_ui.show()
	boton_menu.show()
	get_tree().call_group("tuberias", "queue_free")

func _spawn_pipe() -> void:
	if pipe_scene:
		var pipe = pipe_scene.instantiate()
		add_child(pipe)
		# Le pasamos la velocidad actual al nuevo pipe
		if pipe.has_method("set_speed"):
			pipe.set_speed(velocidad_actual)
		
		pipe.position.x = get_viewport().get_visible_rect().size.x + 60
		pipe.position.y = randf_range(-100, 100)

func _on_bird_died() -> void:
	game_active = false
	pipe_timer.stop()
	get_tree().call_group("tuberias", "queue_free") # Limpia la pantalla
	
	await get_tree().create_timer(0.5).timeout
	if boton_menu:
		boton_menu.show()

func _on_boton_menu_pressed() -> void:
	print("Presionado")
	get_tree().change_scene_to_file(NEXT_SCENE)
	
	

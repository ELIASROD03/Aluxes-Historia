extends CharacterBody2D

@export var follow_distance: float = 40.0
@export var speed: float = 120.0
@export var id_dialogo: String = "encuentro_atlas"

@export var tex_idle: Texture2D
@export var hframes_idle: int = 9

var following: bool = false
var player: Node2D
var cuadro_dialogo: Node
var zona_activada: bool = false

@onready var sprite = $Sprite2D if has_node("Sprite2D") else null

func _ready():
	# Buscar al jugador en la escena actual
	player = get_tree().current_scene.find_child("Player", true, false)
	cuadro_dialogo = get_tree().current_scene.find_child("CuadroDialogo", true, false)
	
	# Ignorar colisiones con el jugador y cualquier otro NPC (CharacterBody2D)
	var personajes = get_tree().current_scene.find_children("*", "CharacterBody2D", true, false)
	for p in personajes:
		if p != self:
			add_collision_exception_with(p)
	
	if cuadro_dialogo:
		# Conectamos la señal que agregamos en dialogo_manager.gd
		cuadro_dialogo.dialogo_terminado.connect(_on_dialogo_terminado)
		
	var area = $Area2D if has_node("Area2D") else null
	if area:
		area.body_entered.connect(_on_body_entered)

	# Si ya conocemos a Atlas de una escena anterior, lo seguimos inmediatamente y quitamos el diálogo
	if has_node("/root/Global") and get_node("/root/Global").get("conoce_atlas") == true:
		following = true
		if area:
			area.queue_free()

func _on_body_entered(body: Node2D):
	if not zona_activada and (body.name == "Player" or body is Player):
		if cuadro_dialogo and cuadro_dialogo.has_method("iniciar_dialogo") and not cuadro_dialogo.visible:
			zona_activada = true
			cuadro_dialogo.iniciar_dialogo(id_dialogo)

func _on_dialogo_terminado(id: String):
	if id == id_dialogo:
		following = true
		if has_node("/root/Global"):
			get_node("/root/Global").set("conoce_atlas", true)

func _set_texture(new_tex: Texture2D, frames: int) -> void:
	if sprite and sprite.texture != new_tex:
		sprite.texture = new_tex
		sprite.hframes = frames
		sprite.vframes = 1
		sprite.frame = 0
		if sprite.has_method("reset_timer"):
			sprite.reset_timer()

func _physics_process(delta):
	# Si no estamos siguiendo o estamos en diálogo, no nos movemos (solo gravedad)
	if not following or Global.en_dialogo or not player:
		velocity.x = 0
		if tex_idle:
			_set_texture(tex_idle, hframes_idle)
		if not is_on_floor():
			velocity.y += 980 * delta
		move_and_slide()
		return

	# Distancia del robot al jugador
	var distance_to_player = player.global_position.x - global_position.x

	# Si la distancia es mayor a la permitida, seguimos al jugador
	if abs(distance_to_player) > follow_distance:
		var dir = sign(distance_to_player)
		velocity.x = dir * speed
		
		if tex_idle:
			_set_texture(tex_idle, hframes_idle)
		
		# Opcional: Voltear el sprite según la dirección
		if sprite:
			sprite.flip_h = (dir > 0)
	else:
		velocity.x = 0
		if tex_idle:
			_set_texture(tex_idle, hframes_idle)

	# Aplicar gravedad
	if not is_on_floor():
		velocity.y += 980 * delta

	move_and_slide()

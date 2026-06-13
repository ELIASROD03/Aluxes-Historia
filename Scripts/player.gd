class_name Player
extends CharacterBody2D

const SPEED = 150.0
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite = $Sprite2D

var tex_idle: Texture2D
var tex_walk: Texture2D

func debug_log(msg: String):
	var f = FileAccess.open("user://debug_log.txt", FileAccess.READ_WRITE)
	if not f:
		f = FileAccess.open("user://debug_log.txt", FileAccess.WRITE)
	f.seek_end()
	f.store_line(msg)
	f.close()
	print(msg)

func _ready() -> void:
	var f = FileAccess.open("user://debug_log.txt", FileAccess.WRITE)
	if f: f.close() # clear log
	
	debug_log("Player _ready iniciado")
	if has_node("/root/Global"):
		var GlobalNode = get_node("/root/Global")
		debug_log("GlobalNode encontrado")
		
		var ruta_idle = GlobalNode.get("ruta_spritesheet")
		debug_log("Ruta idle: " + str(ruta_idle))
		if typeof(ruta_idle) == TYPE_STRING and ruta_idle != "":
			var loaded_idle = load(ruta_idle)
			if loaded_idle: 
				tex_idle = loaded_idle
				debug_log("Cargada textura idle ok")
			
		var ruta_walk = GlobalNode.get("ruta_walk")
		debug_log("Ruta walk: " + str(ruta_walk))
		if typeof(ruta_walk) == TYPE_STRING and ruta_walk != "":
			var loaded_walk = load(ruta_walk)
			if loaded_walk: 
				tex_walk = loaded_walk
				debug_log("Cargada textura walk ok")
	else:
		debug_log("No se encontro /root/Global en _ready")

	if not tex_idle:
		tex_idle = load("res://Images/Personajes/Personajes_Principales/Personaje1/respirando/untitled(7).png")
	if not tex_walk:
		tex_walk = load("res://Images/Personajes/Personajes_Principales/Personaje1/walk.png")

	if tex_idle:
		debug_log("Asignando textura idle inicial")
		_set_texture(tex_idle, 9, true)

func _set_texture(new_tex: Texture2D, frames: int, force: bool = false) -> void:
	var needs_update = false
	if force:
		needs_update = true
	elif sprite.texture != new_tex:
		needs_update = true
		
	if new_tex and needs_update:
		sprite.texture = new_tex
		sprite.hframes = frames
		sprite.vframes = 1
		sprite.frame = 0
		if sprite.has_method("reset_timer"):
			sprite.reset_timer()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	var en_dialogo = false
	if has_node("/root/Global"):
		var GlobalNode = get_node("/root/Global")
		en_dialogo = GlobalNode.get("en_dialogo") == true

	if en_dialogo:
		velocity.x = 0.0
		if tex_idle:
			_set_texture(tex_idle, 9)
	else:
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
			sprite.flip_h = direction < 0
			if tex_walk:
				_set_texture(tex_walk, 9)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if tex_idle:
				_set_texture(tex_idle, 9)

	move_and_slide()

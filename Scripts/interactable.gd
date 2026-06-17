extends Area2D

@export var texto_interaccion: String = "Activar"
# Ruta al sprite que se iluminará (opcional)
@export var sprite_objetivo: NodePath
# Escena a cargar opcionalmente. Si está vacía, puedes usar señales.
@export var escena_destino: String = ""

signal interacted

var can_interact: bool = false
var sprite: Sprite2D
var label: Label

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Crear un texto flotante dinámicamente
	label = Label.new()
	label.text = texto_interaccion
	label.visible = false
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	# Centramos el texto un poco arriba del objeto
	label.position = Vector2(-50, -50)
	
	# Darle estilo de teclado/botón
	label.add_theme_color_override("font_color", Color.YELLOW)
	label.add_theme_font_size_override("font_size", 12)
	add_child(label)
	
	if not sprite_objetivo.is_empty():
		sprite = get_node(sprite_objetivo) as Sprite2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" or body is Player:
		can_interact = true
		label.visible = true
		if sprite:
			# Iluminar el sprite subiendo los canales RGB por encima de 1
			sprite.modulate = Color(1.5, 1.5, 1.5)

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player" or body is Player:
		can_interact = false
		label.visible = false
		if sprite:
			# Restaurar color normal
			sprite.modulate = Color(1.0, 1.0, 1.0)

func _input(event: InputEvent) -> void:
	if can_interact and visible:
		if event.is_action_pressed("ui_accept"):
			# Evitar que se active si estamos hablando en un cuadro de diálogo
			if has_node("/root/Global") and get_node("/root/Global").en_dialogo:
				return
				
			interacted.emit()
			
			# Si le configuramos una escena, viaja automáticamente
			if escena_destino != "":
				get_tree().change_scene_to_file(escena_destino)

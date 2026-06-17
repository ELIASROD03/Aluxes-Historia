extends CanvasLayer

var color_rect: ColorRect

func _ready() -> void:
	layer = 100 # Asegura que la transición cubra toda la pantalla
	color_rect = ColorRect.new()
	color_rect.color = Color(0, 0, 0, 0) # Transparente por defecto
	color_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(color_rect)

func change_scene(target_path: String) -> void:
	# Bloquear clics mientras ocurre la transición
	color_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	
	# 1. Animación: fundido a negro (fade out)
	var tween = create_tween()
	tween.tween_property(color_rect, "color", Color(0, 0, 0, 1), 0.5)
	await tween.finished
	
	# Cambiar la escena
	get_tree().change_scene_to_file(target_path)
	
	# Esperar un pequeño momento a que la escena cargue
	await get_tree().process_frame
	
	# 2. Animación: aclarar a transparente (fade in)
	var tween2 = create_tween()
	tween2.tween_property(color_rect, "color", Color(0, 0, 0, 0), 0.5)
	await tween2.finished
	
	# Volver a permitir clics
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

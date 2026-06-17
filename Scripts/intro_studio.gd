extends Control

@onready var uady_label: Label = $UADYLabel
@onready var title_label: Label = $TitleLabel

func _ready() -> void:
	# Inicializamos ambos textos como transparentes
	uady_label.modulate = Color(1, 1, 1, 0)
	title_label.modulate = Color(1, 1, 1, 0)
	
	_play_intro()

func _play_intro() -> void:
	# Pequeña pausa antes de empezar
	await get_tree().create_timer(0.5).timeout
	
	# Fade in de "UADY studios presenta"
	var tween1 = create_tween()
	tween1.tween_property(uady_label, "modulate", Color(1, 1, 1, 1), 1.5)
	await tween1.finished
	
	# Pausa para que el jugador lo lea
	await get_tree().create_timer(2.0).timeout
	
	# Fade out de "UADY studios presenta"
	var tween2 = create_tween()
	tween2.tween_property(uady_label, "modulate", Color(1, 1, 1, 0), 1.0)
	await tween2.finished
	
	# Fade in del título del juego
	var tween3 = create_tween()
	tween3.tween_property(title_label, "modulate", Color(1, 1, 1, 1), 1.5)
	await tween3.finished
	
	# Pausa para que el jugador lo lea
	await get_tree().create_timer(2.5).timeout
	
	# Cambiar a la escena del prólogo usando el Autoload SceneTransition
	SceneTransition.change_scene("res://Scenes/Prologo.tscn")

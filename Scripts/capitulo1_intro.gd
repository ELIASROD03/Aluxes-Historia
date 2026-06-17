extends Control

func _ready() -> void:
	# Esperar 4 segundos y cambiar a la escena Tenoch
	await get_tree().create_timer(4.0).timeout
	SceneTransition.change_scene("res://Scenes/Laboratorio.tscn")

func _on_menu_btn_pressed() -> void:
	SceneTransition.change_scene("res://Scenes/MenuPrincipal.tscn")

extends Control

func _ready() -> void:
	# Esperar 4 segundos y cambiar a la escena Tenoch
	await get_tree().create_timer(4.0).timeout
	get_tree().change_scene_to_file("res://Scenes/Tenoch.tscn")

func _on_menu_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MenuPrincipal.tscn")

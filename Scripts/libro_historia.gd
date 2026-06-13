extends Control

func _ready():
	# Buscamos el botón sin importar en qué parte de la escena lo hayas puesto
	var btn = find_child("exit_book_btn", true, false)
	if btn:
		btn.pressed.connect(_on_exit_book_btn_pressed)

func _on_exit_book_btn_pressed():
	get_tree().change_scene_to_file("res://Scenes/MenuPrincipal.tscn")

func _input(event):
	# Opcional: También te deja regresar presionando la tecla Esc
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://Scenes/MenuPrincipal.tscn")

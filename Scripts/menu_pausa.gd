extends CanvasLayer

@onready var panel_pausa = $PanelPausa
@onready var btn_pausa = $BtnPausa

var mouse_mode_previo = Input.MOUSE_MODE_VISIBLE

func _ready():
	panel_pausa.hide()
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_delta: float) -> void:
	if has_node("/root/Global"):
		var en_dialogo = get_node("/root/Global").get("en_dialogo")
		if get_tree().paused:
			btn_pausa.visible = false
		else:
			btn_pausa.visible = not en_dialogo

func _on_btn_pausa_pressed():
	alternar_pausa()

func alternar_pausa():
	var pausado = not get_tree().paused
	get_tree().paused = pausado
	panel_pausa.visible = pausado
	
	if pausado:
		mouse_mode_previo = Input.get_mouse_mode()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(mouse_mode_previo)
	
	# Ocultar controles táctiles al pausar y mostrarlos al reanudar si no estamos en diálogo
	var controles = get_tree().current_scene.find_child("ControlesTactiles", true, false)
	if controles:
		if pausado:
			controles.hide()
		else:
			var en_dialogo = false
			if has_node("/root/Global"):
				en_dialogo = get_node("/root/Global").get("en_dialogo")
			if not en_dialogo:
				controles.show()

func _on_btn_reanudar_pressed():
	alternar_pausa()

func _on_btn_ir_menu_pressed():
	alternar_pausa()
	get_tree().change_scene_to_file("res://Scenes/MenuPrincipal.tscn")

func _on_btn_guardar_pressed():
	print("Partida guardada.")
	# Puedes agregar aquí la lógica para guardar si tienes un sistema en Global:
	# if has_node("/root/Global") and get_node("/root/Global").has_method("guardar_partida"):
	# 	get_node("/root/Global").guardar_partida()

func _on_btn_guardar_salir_pressed():
	_on_btn_guardar_pressed()
	alternar_pausa()
	get_tree().change_scene_to_file("res://Scenes/MenuPrincipal.tscn")

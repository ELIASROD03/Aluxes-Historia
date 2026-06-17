class_name TenochManager
extends Node2D

@onready var cuadro_dialogo = find_child("CuadroDialogo", true, false)
@onready var limites_mapa = find_child("LimitesCamara", true, false)

func _ready() -> void:
	if cuadro_dialogo and cuadro_dialogo.has_method("iniciar_dialogo"):
		cuadro_dialogo.iniciar_dialogo("inicio_tenoch")

	# Ajuste dinámico de cámara
	if limites_mapa:
		var player = find_child("Player", true, false)
		if player:
			var camara = player.get_node("Camera2D")
			if camara:
				camara.limit_left = int(limites_mapa.global_position.x)
				camara.limit_top = int(limites_mapa.global_position.y)
				camara.limit_right = int(limites_mapa.global_position.x + limites_mapa.size.x)
				camara.limit_bottom = int(limites_mapa.global_position.y + limites_mapa.size.y)

extends Node2D

@onready var limites_mapa = $LimitesCamara

func _ready() -> void:
	# Buscamos al jugador en la escena actual
	var player = find_child("Player", true, false)
	if player:
		var camara = player.get_node("Camera2D")
		if camara:
			camara.limit_left = int(limites_mapa.global_position.x)
			camara.limit_top = int(limites_mapa.global_position.y)
			camara.limit_right = int(limites_mapa.global_position.x + limites_mapa.size.x)
			camara.limit_bottom = int(limites_mapa.global_position.y + limites_mapa.size.y)

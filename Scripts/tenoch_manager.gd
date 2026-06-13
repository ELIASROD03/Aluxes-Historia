class_name TenochManager
extends Node2D

# Busca el cuadro de diálogo sin importar en qué capa (CanvasLayer) lo hayas metido
@onready var cuadro_dialogo = find_child("CuadroDialogo", true, false)

func _ready() -> void:
	# Verificamos que el cuadro exista y tenga la función
	if cuadro_dialogo and cuadro_dialogo.has_method("iniciar_dialogo"):
		# Iniciamos el diálogo del archivo JSON
		cuadro_dialogo.iniciar_dialogo("inicio_tenoch")

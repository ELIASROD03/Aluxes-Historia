class_name ZonaDialogo
extends Area2D

@export var id_dialogo: String = "dialogo_soldado"

func _ready() -> void:
	# Nos conectamos a la señal para saber cuándo alguien toca la colisión
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# Comprobamos que el que haya tocado la zona sea el jugador
	if body.name == "Player" or body is Player:
		var cuadro_dialogo = get_tree().current_scene.find_child("CuadroDialogo", true, false)
		
		# Verificamos que el cuadro de diálogo no se esté mostrando actualmente 
		# (para no interrumpir otro diálogo si se pisan dos zonas a la vez)
		if cuadro_dialogo and cuadro_dialogo.has_method("iniciar_dialogo") and not cuadro_dialogo.visible:
			cuadro_dialogo.iniciar_dialogo(id_dialogo)
			
			# Opcional: Apagamos la zona para que no vuelva a lanzar el diálogo
			# si el jugador se queda parado ahí y se mueve un píxel.
			# Si quieres que se repita siempre, puedes borrar esta línea.
			set_deferred("monitoring", false)

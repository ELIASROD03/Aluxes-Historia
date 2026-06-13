extends Area2D

@export var move_speed: float = 200.0

@warning_ignore("unused_signal")
signal pipe_passed

var moving: bool = true
var scored: bool = false


func _ready() -> void:
	# body_entered detecta CharacterBody2D correctamente
	body_entered.connect(_on_body_entered)


func _process(delta: float) -> void:
	if not moving:
		return
	position.x -= move_speed * delta
	if position.x < -300:
		queue_free()


func stop() -> void:
	moving = false


func _on_body_entered(body: Node2D) -> void:
	# body ES el Atlas (CharacterBody2D) directamente
	if body.has_method("die"):
		body.die()




func _on_punto_area_body_entered(body: Node2D) -> void:
	# Verificamos que sea el pájaro (usando el nombre o el grupo 'jugador')
	if body.name == "atlas" or body.is_in_group("jugador"):
		# 1. Avisamos al script principal que sume un punto
		get_tree().call_group("mundo", "añadir_punto")
		
		# 2. Desactivamos el área para que no se sumen puntos infinitos al pasar
		# Usamos set_deferred porque no se pueden cambiar físicas durante una colisión
		$PuntoArea/CollisionShape2D.set_deferred("disabled", true)
		
		print("¡Punto anotado!")
	

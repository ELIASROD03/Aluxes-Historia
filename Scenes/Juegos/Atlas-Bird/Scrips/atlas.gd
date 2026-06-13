extends CharacterBody2D

@export var jump_force: float = -400.0
@export var gravity: float = 1200.0
@export var rotation_speed: float = 5.0

var is_dead: bool = false
var game_started: bool = false

signal bird_died


func _physics_process(delta: float) -> void:
	if not game_started:
		return

	velocity.y += gravity * delta
	move_and_slide()

	# Rotar el pájaro según velocidad vertical
	var target_rot = clamp(velocity.y / 600.0, -1.0, 1.0) * 90.0
	rotation_degrees = lerp(rotation_degrees, target_rot, rotation_speed * delta)


func jump() -> void:
	if is_dead:
		return
	game_started = true
	velocity.y = jump_force


func die() -> void:
	if is_dead:
		return
	is_dead = true
	game_started = false
	emit_signal("bird_died")

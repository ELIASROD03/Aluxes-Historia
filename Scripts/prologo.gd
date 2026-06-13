extends Control

@onready var texture_rect = $TextureRect
@onready var label = $ColorRect/Label
@onready var timer = $Timer

var sequence = [
	{
		"image": "res://Images/Cinematica/Casa.png",
		"text": "Mérida, Yucatán. Una tarde pacífica en las tierras donde los antiguos espíritus de la naturaleza aún vigilan desde las sombras..."
	},
	{
		"image": "res://Images/Cinematica/Escritorio.png",
		"text": "Mi padre, el Doctor Juan Pérez, investigaba el tejido del tiempo... hasta que una noche desapareció misteriosamente sin dejar rastro."
	},
	{
		"image": "res://Images/Cinematica/Pasadizo.png",
		"text": "Buscando respuestas en el patio, descubrí el acceso a su laboratorio subterráneo... El aire se sentía cargado de una traviesa magia ancestral."
	},
	{
		"image": "res://Images/Cinematica/Laboratorio.png",
		"text": "Su máxima obra estaba encendida. El espacio-tiempo ha sido alterado por las travesuras de tres Aluxes... ¡Es hora de viajar al pasado y salvar a papá!"
	}
]

var current_step = -1
var tween : Tween

func _ready():
	avanzar()

func avanzar():
	current_step += 1
	if current_step >= sequence.size():
		finalizar()
		return
		
	var step_data = sequence[current_step]
	texture_rect.texture = load(step_data["image"])
	label.text = step_data["text"]
	label.visible_ratio = 0.0
	
	if tween:
		tween.kill()
	tween = create_tween()
	var duracion_texto = max(1.0, label.text.length() * 0.04)
	tween.tween_property(label, "visible_ratio", 1.0, duracion_texto)
	tween.tween_callback(iniciar_espera)

func iniciar_espera():
	timer.start(3.0)

func _on_timer_timeout():
	avanzar()

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if tween and tween.is_running():
			tween.kill()
			label.visible_ratio = 1.0
			iniciar_espera()
		else:
			timer.stop()
			avanzar()
	elif event is InputEventKey and event.pressed and (event.keycode == KEY_ENTER or event.keycode == KEY_SPACE):
		if tween and tween.is_running():
			tween.kill()
			label.visible_ratio = 1.0
			iniciar_espera()
		else:
			timer.stop()
			avanzar()

func _on_saltar_pressed():
	finalizar()

func finalizar():
	get_tree().change_scene_to_file("res://Scenes/MenuPrincipal.tscn")

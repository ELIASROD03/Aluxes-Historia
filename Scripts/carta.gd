extends Control

signal card_flipped(card)

var id: String = ""
var is_flipped: bool = false
var is_matched: bool = false

@onready var button = $Button
@onready var front_bg = $Button/FrontBackground
@onready var front_image = $Button/FrontImage
@onready var front_text = $Button/FrontText

var back_texture = preload("res://Images/Fondos/carta_volteada.png")

func setup(p_id: String, type: String, content: String):
	id = p_id
	button.texture_normal = back_texture
	
	front_bg.hide()
	front_image.hide()
	front_text.hide()
	
	if type == "imagen":
		var tex = load(content)
		if tex:
			front_image.texture = tex
	elif type == "texto":
		front_text.text = content

func _on_pressed() -> void:
	if is_flipped or is_matched:
		return
		
	emit_signal("card_flipped", self)

func flip_card():
	var tween = create_tween()
	tween.tween_property(button, "scale:x", 0.0, 0.15)
	await tween.finished
	
	is_flipped = !is_flipped
	
	if is_flipped:
		button.texture_normal = null 
		front_bg.show()
		if front_image.texture != null:
			front_image.show()
		if front_text.text != "":
			front_text.show()
	else:
		button.texture_normal = back_texture
		front_bg.hide()
		front_image.hide()
		front_text.hide()
		
	var tween2 = create_tween()
	tween2.tween_property(button, "scale:x", 1.0, 0.15)
	await tween2.finished

func match_found():
	is_matched = true
	var tween = create_tween()
	tween.tween_property(button, "modulate", Color(0.5, 0.5, 0.5, 0.8), 0.3)

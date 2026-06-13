class_name Respirador
extends Sprite2D

@export var fps: float = 8.0
var anim_timer: float = 0.0

func _ready() -> void:
	if texture and hframes == 1:
		var w = texture.get_width()
		var h = texture.get_height()
		if h > 0:
			hframes = max(1, int(w / h))

func _process(delta: float) -> void:
	if hframes > 1 and fps > 0:
		anim_timer += delta
		if anim_timer >= 1.0 / fps:
			frame = (frame + 1) % hframes
			anim_timer = 0.0

func reset_timer() -> void:
	anim_timer = 0.0
	frame = 0

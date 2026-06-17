extends Control

signal juego_completado

@onready var flow_text = $HFlowText
@onready var mira_detector = $MiraDetector
@onready var barra_carga = $MiraDetector/BarraCarga
@onready var beep_audio = $BeepAudio
@onready var beep_timer = $BeepTimer
@onready var menu_reemplazo = $MenuReemplazo
@onready var btn_analizar = $BtnAnalizarAtlas
@onready var btn_ayuda = $BtnAyudaAtlas
@onready var imagen_detector = $MiraDetector/ImagenDetector

@onready var opciones_cartas = {
	"opcion_a": $MenuReemplazo/VBox/HBoxCartas/OpcionA,
	"opcion_b": $MenuReemplazo/VBox/HBoxCartas/OpcionB,
	"opcion_c": $MenuReemplazo/VBox/HBoxCartas/OpcionC
}

var font_normal = preload("res://fonts/VCR_OSD_MONO_1.001.ttf")

# Variables que ahora se llenarán desde el JSON
var historia_base = ""
var datos_impostoras = {}
var nivel_a_cargar = "nivel_1" # Puedes cambiar esto desde otro script antes de que se ejecute el _ready()

# Variables de estado del minijuego
var zona_activa = null
var tiempo_hover = 0.0
var tiempo_necesario = 3.0
var escaneando = true
var palabras_corregidas = 0
var velocidad_parpadeo = 2.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	menu_reemplazo.hide()
	btn_analizar.disabled = true
	barra_carga.value = 0
	
	for key in opciones_cartas.keys():
		opciones_cartas[key].connect("pressed", Callable(self, "_on_carta_seleccionada").bind(key))
	
	cargar_datos_nivel(nivel_a_cargar)
	actualizar_texto()

func cargar_datos_nivel(nivel_id: String):
	var file = FileAccess.open("res://palabras.json", FileAccess.READ)
	if not file: return
	
	var json = JSON.new()
	if json.parse(file.get_as_text()) == OK:
		var data = json.data
		if data.has(nivel_id):
			historia_base = data[nivel_id]["historia"]
			
			datos_impostoras.clear()
			var zonas_json = data[nivel_id]["zonas"]
			for z_id in zonas_json:
				datos_impostoras[z_id] = zonas_json[z_id]
				# Añadimos el estado actual vacío por defecto
				datos_impostoras[z_id]["reemplazo_actual"] = ""

func actualizar_texto():
	# Limpia los nodos actuales
	for child in flow_text.get_children():
		child.queue_free()
		
	# Procesamos la historia para preservar los saltos de línea
	var lineas = historia_base.split("\n")
	
	for i in range(lineas.size()):
		var linea = lineas[i]
		var palabras = linea.split(" ")
		
		for p in palabras:
			if p == "": continue
			
			if p.begins_with("{") and p.ends_with("}"):
				var zona_id = p.replace("{", "").replace("}", "")
				if not datos_impostoras.has(zona_id): continue
				
				var label = Label.new()
				label.name = zona_id
				label.set_meta("zona_id", zona_id)
				
				var txt = datos_impostoras[zona_id]["texto_original"]
				var color_fuente = Color.BLACK
				if datos_impostoras[zona_id]["reemplazo_actual"] != "":
					txt = datos_impostoras[zona_id]["reemplazo_actual"]
					color_fuente = Color("1f9fb4ff") # Ámbar
					
				label.text = txt + " "
				label.add_theme_font_override("font", font_normal)
				label.add_theme_font_size_override("font_size", 14)
				label.add_theme_color_override("font_color", color_fuente)
				label.add_to_group("zonas_impostoras")
				label.mouse_filter = Control.MOUSE_FILTER_PASS
				
				flow_text.add_child(label)
			else:
				var label = Label.new()
				label.text = p + " "
				label.add_theme_font_override("font", font_normal)
				label.add_theme_font_size_override("font_size", 14)
				label.add_theme_color_override("font_color", Color.BLACK)
				flow_text.add_child(label)
				
		# Añadir un salto de línea si no es la última línea
		if i < lineas.size() - 1:
			var br = Control.new()
			br.custom_minimum_size = Vector2(400, 15) # Ancho exacto del pergamino para forzar salto sin salir de la pantalla
			flow_text.add_child(br)

func _process(delta):
	if not escaneando:
		mira_detector.hide()
		return
		
	mira_detector.show()
	var mouse_pos = get_global_mouse_position()
	mira_detector.global_position = mouse_pos - (mira_detector.size / 2.0)
	
	var distancia_minima = 9999.0
	var zona_mas_cercana = null
	var en_hover = null
	
	var zonas = get_tree().get_nodes_in_group("zonas_impostoras")
	for zona in zonas:
		if not zona.has_meta("zona_id"): continue
		var id = zona.get_meta("zona_id")
			
		var rect = zona.get_global_rect()
		var centro = rect.position + rect.size / 2.0
		var dist = mouse_pos.distance_to(centro)
		
		if dist < distancia_minima:
			distancia_minima = dist
			zona_mas_cercana = zona
			
		if rect.has_point(mouse_pos):
			en_hover = zona
			
	# Actualizar el contador Geiger
	if zona_mas_cercana != null:
		actualizar_geiger(distancia_minima)
		
		if en_hover != null:
			tiempo_hover += delta
			barra_carga.value = (tiempo_hover / tiempo_necesario) * 100
			
			if tiempo_hover >= tiempo_necesario:
				abrir_menu_reemplazo(en_hover.get_meta("zona_id"))
		else:
			tiempo_hover = 0.0
			barra_carga.value = 0
	else:
		beep_timer.stop()
		tiempo_hover = 0.0
		barra_carga.value = 0
		
	# Animar el parpadeo del detector
	if escaneando and imagen_detector:
		var oscilacion = (sin(Time.get_ticks_msec() * 0.001 * velocidad_parpadeo) + 1.0) / 2.0
		imagen_detector.modulate.a = 0.4 + (oscilacion * 0.6)

func actualizar_geiger(distancia: float):
	if distancia > 250:
		beep_timer.stop()
		velocidad_parpadeo = 2.0
		return
		
	var nuevo_tiempo = 1.5
	if distancia < 40: 
		nuevo_tiempo = 0.1 # Muy rápido
		velocidad_parpadeo = 25.0
	elif distancia < 100: 
		nuevo_tiempo = 0.4
		velocidad_parpadeo = 15.0
	elif distancia < 180: 
		nuevo_tiempo = 0.8
		velocidad_parpadeo = 8.0
		
	if beep_timer.is_stopped() or abs(beep_timer.wait_time - nuevo_tiempo) > 0.1:
		beep_timer.wait_time = max(0.1, nuevo_tiempo)
		beep_timer.start()

func _on_beep_timer_timeout():
	if beep_audio.stream != null: beep_audio.play()

func abrir_menu_reemplazo(zona_id: String):
	escaneando = false
	beep_timer.stop()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	zona_activa = zona_id
	
	var opciones = datos_impostoras[zona_id]["opciones"]
	opciones_cartas["opcion_a"].get_node("Texto").text = opciones[0]["texto"]
	opciones_cartas["opcion_b"].get_node("Texto").text = opciones[1]["texto"]
	opciones_cartas["opcion_c"].get_node("Texto").text = opciones[2]["texto"]
	
	menu_reemplazo.show()

func _on_carta_seleccionada(btn_key: String):
	menu_reemplazo.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	escaneando = true
	tiempo_hover = 0.0
	barra_carga.value = 0
	
	var indice = 0
	if btn_key == "opcion_b": indice = 1
	elif btn_key == "opcion_c": indice = 2
		
	var seleccion = datos_impostoras[zona_activa]["opciones"][indice]
	datos_impostoras[zona_activa]["reemplazo_actual"] = seleccion["texto"]
	
	palabras_corregidas += 1
	btn_analizar.disabled = false
	actualizar_texto()

func _on_btn_analizar_atlas_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	escaneando = false
	
	var todas_correctas = true
	for zona_id in datos_impostoras:
		if datos_impostoras[zona_id]["reemplazo_actual"] != datos_impostoras[zona_id]["correcta"]:
			todas_correctas = false
			break
			
	if todas_correctas:
		# ¡Éxito!
		juego_completado.emit()
	else:
		# Incorrecto, mostrar Cuadro de Diálogo
		var cuadro = get_node_or_null("CuadroDialogo")
		if cuadro and cuadro.has_method("iniciar_dialogo"):
			cuadro.iniciar_dialogo("error_palabras")
			if not cuadro.is_connected("dialogo_terminado", Callable(self, "_on_error_dialogo_terminado")):
				cuadro.connect("dialogo_terminado", Callable(self, "_on_error_dialogo_terminado"))
		else:
			# Respaldo por si no está el cuadro
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			escaneando = true

func _on_error_dialogo_terminado(id_dialogo):
	if id_dialogo == "error_palabras":
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		escaneando = true
	
func _on_btn_ayuda_atlas_pressed():
	print("Usando comodín de ayuda de Atlas")

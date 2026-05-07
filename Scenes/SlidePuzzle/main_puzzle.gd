extends Node2D

var grid_size := 3          # 3 o 4
var tile_size := 150        # píxeles por pieza
var tiles := []             # array 1D del estado actual
var empty_index := 0        # posición del hueco
var intentos := 0
var max_intentos := 2
var resolviendo := false

@onready var grid = $PuzzleGrid
@onready var label_intentos = $UI/VBoxContainer/LabelIntentos
@onready var msg_victoria = $MensajeVictoria

func _ready():
	init_puzzle(3)

func init_puzzle(size: int):
	grid_size = size
	intentos = 0
	resolviendo = false
	label_intentos.text = "Intentos de rendirse: 0 / %d" % max_intentos
	msg_victoria.visible = false
	generar_tablero()

func generar_tablero():
	# Limpia nodos previos
	for child in grid.get_children():
		child.queue_free()

	# Estado resuelto: [1, 2, 3, ..., n*n-1, 0]  (0 = hueco)
	var total = grid_size * grid_size
	tiles = range(1, total) + [0]   # GDScript 4: range devuelve array
	tiles = Array(range(1, total))
	tiles.append(0)

	# Mezcla válida (número par de inversiones)
	mezclar()

	empty_index = tiles.find(0)

	# Configura el GridContainer
	grid.columns = grid_size

	# Crea las piezas visuales
	for i in total:
		var valor = tiles[i]
		var btn = Button.new()
		btn.custom_minimum_size = Vector2(tile_size, tile_size)
		if valor == 0:
			btn.text = ""
			btn.modulate = Color(0, 0, 0, 0)   # invisible
		else:
			btn.text = str(valor)
			btn.pressed.connect(_on_piece_pressed.bind(i))
		grid.add_child(btn)

func mezclar():
	# Mezcla asegurando que sea resoluble
	var total = tiles.size()
	for _i in range(total * 10):
		var a = randi() % total
		var b = randi() % total
		var tmp = tiles[a]
		tiles[a] = tiles[b]
		tiles[b] = tmp
	# Verificar paridad; si no es resoluble, hacer un swap adicional
	if not es_resoluble():
		# Swap en las dos primeras piezas no-cero
		var idx0 = 0 if tiles[0] != 0 else 1
		var idx1 = 1 if tiles[0] != 0 else 2
		var tmp = tiles[idx0]
		tiles[idx0] = tiles[idx1]
		tiles[idx1] = tmp

func es_resoluble() -> bool:
	var inversiones = 0
	var n = tiles.size()
	for i in n:
		for j in range(i + 1, n):
			if tiles[i] != 0 and tiles[j] != 0 and tiles[i] > tiles[j]:
				inversiones += 1
	if grid_size % 2 == 1:          # tablero impar (3×3)
		return inversiones % 2 == 0
	else:                           # tablero par (4×4)
		var fila_vacio = tiles.find(0) / grid_size
		var fila_desde_abajo = grid_size - fila_vacio
		return (inversiones + fila_desde_abajo) % 2 == 1

# ── Mover pieza ──────────────────────────────────────────────────────────────

func _on_piece_pressed(index: int):
	if resolviendo:
		return
	if es_adyacente(index, empty_index):
		mover_pieza(index)
		actualizar_visual()
		if es_victoria():
			mostrar_victoria()

func es_adyacente(a: int, b: int) -> bool:
	var ra = a / grid_size
	var ca = a % grid_size
	var rb = b / grid_size
	var cb = b % grid_size
	return (abs(ra - rb) + abs(ca - cb)) == 1

func mover_pieza(index: int):
	tiles[empty_index] = tiles[index]
	tiles[index] = 0
	empty_index = index

# ── Botón rendirse ────────────────────────────────────────────────────────────

func _on_btn_rendirse_pressed():
	if resolviendo:
		return
	intentos += 1
	label_intentos.text = "Intentos de rendirse: %d / %d" % [intentos, max_intentos]
	if intentos >= max_intentos:
		autocomplete()

# ── Autocompletar (BFS / movimientos secuenciales simples) ────────────────────

func autocomplete():
	resolviendo = true
	# Construir solución goal
	var meta = Array(range(1, grid_size * grid_size))
	meta.append(0)
	# Animar movimientos hacia la solución
	_resolver_paso_a_paso(meta)

func _resolver_paso_a_paso(meta: Array):
	# Usamos un timer para animar cada paso
	var pasos = _obtener_pasos_solucion(meta)
	_animar_pasos(pasos, 0)

func _animar_pasos(pasos: Array, idx: int):
	if idx >= pasos.size():
		actualizar_visual()
		mostrar_victoria()
		return
	mover_pieza(pasos[idx])
	actualizar_visual()
	await get_tree().create_timer(0.25).timeout
	_animar_pasos(pasos, idx + 1)

# BFS para encontrar los índices a mover en orden
func _obtener_pasos_solucion(meta: Array) -> Array:
	# Estado inicial
	var inicio = tiles.duplicate()
	if inicio == meta:
		return []

	var cola = [[inicio, []]]
	var visitados = {}
	visitados[str(inicio)] = true

	while cola.size() > 0:
		var actual_par = cola.pop_front()
		var estado: Array = actual_par[0]
		var camino: Array = actual_par[1]

		var hueco = estado.find(0)
		var vecinos = _vecinos(hueco)

		for v in vecinos:
			var nuevo = estado.duplicate()
			nuevo[hueco] = nuevo[v]
			nuevo[v] = 0
			var key = str(nuevo)
			if not visitados.has(key):
				var nuevo_camino = camino.duplicate()
				nuevo_camino.append(v)   # el índice que se mueve al hueco
				if nuevo == meta:
					return nuevo_camino
				visitados[key] = true
				cola.append([nuevo, nuevo_camino])
	return []

func _vecinos(idx: int) -> Array:
	var result = []
	var r = idx / grid_size
	var c = idx % grid_size
	if r > 0: result.append(idx - grid_size)
	if r < grid_size - 1: result.append(idx + grid_size)
	if c > 0: result.append(idx - 1)
	if c < grid_size - 1: result.append(idx + 1)
	return result

# ── Visual ────────────────────────────────────────────────────────────────────

func actualizar_visual():
	var children = grid.get_children()
	for i in children.size():
		var btn: Button = children[i]
		var valor = tiles[i]
		if valor == 0:
			btn.text = ""
			btn.modulate = Color(0, 0, 0, 0)
		else:
			btn.text = str(valor)
			btn.modulate = Color(1, 1, 1, 1)
			# Reconectar señal (el índice no cambia, el valor sí)
			for c in btn.pressed.get_connections():
				btn.pressed.disconnect(c.callable)
			btn.pressed.connect(_on_piece_pressed.bind(i))

func es_victoria() -> bool:
	var meta = Array(range(1, grid_size * grid_size))
	meta.append(0)
	return tiles == meta

func mostrar_victoria():
	msg_victoria.text = "🎉 ¡Resuelto!"
	msg_victoria.visible = true

# ── Botones UI ────────────────────────────────────────────────────────────────

func _on_btn_3x3_pressed():
	init_puzzle(3)

func _on_btn_4x4_pressed():
	init_puzzle(4)

func _on_btn_reiniciar_pressed():
	init_puzzle(grid_size)

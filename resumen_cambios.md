# Resumen de Desarrollo - Los Aluxes que cambiaron la Historia

## 🛠️ Cambios Realizados Hoy

1. **Contexto Inicial**:
   - Análisis de la estructura de carpetas de Godot, `MenuPrincipal.tscn`, `Scripts` y el minijuego `Atlas-Bird`.

2. **Nueva Pantalla: "Seleccionar Personaje"**:
   - Se creó la escena `CreacionPersonaje.tscn` y su controlador `creacion_personaje.gd`.
   - Se vinculó exitosamente el botón **"Nueva partida"** del menú de laboratorio con esta nueva escena.
   - La pantalla muestra un diseño recto (sin inclinación), un campo para ingresar nombre y una sección de previsualización.

3. **Selector Dinámico y Sprites**:
   - Se construyó un arreglo dinámico para la navegación de avatares con botones de izquierda y derecha (`<`, `>`).
   - Se añadió el **Personaje 1** y **Personaje 2** procedentes de la carpeta `Images/Personajes/Personajes_Principales/`.
   - Se codificó la importación automática de los frames `000` a `003` de la animación **Idle** (respiración).
   - Se arregló el problema visual de los pixeles borrosos aplicando `texture_filter = 1` (Nearest) en el Sprite de la interfaz.

4. **Fuentes e Interfaz**:
   - Se probó una fuente *Pixel Art* (`PressStart2P-Regular.ttf`) cambiando los tamaños de la interfaz a la mitad. 
   - A petición, se descartó el tema global y se devolvieron los valores de fuentes masivas y legibles de la configuración de Godot original.

5. **Explicación Técnica**:
   - Se explicó el sistema modular para armar avatares en 2D.
   - Se resolvió la duda de por qué Godot crea los archivos `.png.import` automáticamente para serializar metadatos.

## 🚀 Nuevas Implementaciones (Última Sesión)

6. **Cinemática del Prólogo**:
   - Se creó la escena `Prologo.tscn` como la nueva escena principal del juego (`main_scene`).
   - Muestra una secuencia de imágenes tipo novela visual (`Casa`, `Escritorio`, `Pasadizo`, `Laboratorio`) con narración en la parte inferior.
   - Cuenta con transiciones suaves de texto, avance manual (clic/espacio) y un botón de "Saltar".

7. **Reestructuración del Menú Principal**:
   - Se organizó el botón "Gran libro de historia" en `MenuPrincipal.tscn` para abrir un nuevo submenú anidado (`VBox_menu_libro`).
   - Se movió la opción de volver a "Ver Prólogo" dentro de este nuevo menú, junto con un botón de retroceso ("Volver").
   - Se aplicaron animaciones (Tween) para que la navegación sea igual de dinámica.

8. **Mejoras en Creación de Personaje**:
   - Se mejoró la previsualización del avatar: ahora carga los 8 sprites de la carpeta `rotations` para crear una animación continua de giro de 360°.
   - **Validación de nombre:** Se implementó una alerta en pantalla (`AcceptDialog`) que bloquea el avance si el jugador intenta empezar sin haber escrito su nombre.

9. **Introducción al Capítulo 1**:
   - Se diseñó la escena transitoria `Capitulo1Intro.tscn`.
   - Al empezar la aventura desde la selección de personaje, el jugador es llevado a esta pantalla, que muestra el título "Capítulo 1" en dorado con sombra negra y el subtítulo "Alerta en Tenochtitlán: 1519".
   - Contiene temporalmente un botón para regresar al menú principal.

10. **Redimensionamiento para Resolución 640x360 (Pixel Art)**:
	- Se ajustaron los tamaños de fuente (usando múltiplos de 8 como 8, 12, 16) en las interfaces para adaptarse a la nueva resolución base.
	- `MenuPrincipal.tscn`: Reducción de títulos, botones principales y submenús.
	- `CreacionPersonaje.tscn`: Textos, inputs de nombre y botones reducidos. Escala de la previsualización del avatar ajustada de `(4, 4)` a `(2, 2)`.
	- `Prologo.tscn` y `Capitulo1Intro.tscn`: Textos narrativos, títulos y botones de continuar/saltar redimensionados a tamaños más adecuados.

## 🗡️ Desarrollo Escena Tenochtitlán y Sistemas Core (Sesión Actual)

11. **Configuración de la Escena Tenoch**:
	- Se configuró la escena `Tenoch.tscn` añadiendo `ParallaxBackgrounds` para el Volcán y el Templo con `motion_scale` mínimos (0.02 y 0.05) para dar la ilusión de lejanía.
	- Se corrigió el encuadre de la cámara en `Player` ajustando el `zoom` a `(1, 1)` para que encaje exactamente con la resolución de 640x360 del proyecto.

12. **Sistema Global y Persistencia de Datos**:
	- Se programó el script `global.gd` y se registró como un *AutoLoad* en `project.godot`.
	- Ahora el juego almacena en la memoria global qué personaje se eligió y transfiere sus rutas de texturas (`ruta_spritesheet` y `ruta_walk`) de forma segura a cualquier nivel.

13. **Sistemas de Animación Inteligente (Spritesheets)**:
	- **Selección de personaje:** Se cambió `creacion_personaje.gd` para leer spritesheets en tiras enteras (ej. 576x64), cortándolas en tiempo real con `AtlasTexture` (9 fotogramas).
	- **Script Reusable (`respirador.gd`)**: Se diseñó un script que, al ponérselo a cualquier `Sprite2D`, calcula matemáticamente el número de fotogramas basándose en la resolución de la textura. Esto reparó el fallo del soldado (384x64px -> 6 fotogramas) para que no se viera entrecortado.
	- **Player State Machine Básica:** `player.gd` ahora alterna inteligentemente entre texturas de estar quieto y caminar según los controles, revirtiendo la imagen al detenerse.

14. **Motor de Diálogos por JSON**:
	- Se implementó un archivo externo estructurado `dialogos.json` que actúa como base de datos para la narrativa, permitiendo crear pláticas complejas con personaje, texto y retrato sin tocar el código.
	- Se escribió `dialogo_manager.gd` que lee y procesa el JSON al vuelo.
	- **Correcciones UI:** 
		- Se resolvió el difuminado y deformación metiendo el cuadro de diálogo dentro de un `CanvasLayer`, volviéndolo inmune a la cámara y dejándolo fijo a la pantalla.
		- Se habilitó *Autowrap* nativo para contener los textos.
		- Se arregló el tamaño monstruoso de la alerta en la creación de personajes (`AcceptDialog`) forzándole cortes de línea y límites estrictos (200x100px).

15. **Interacciones, Colisiones y Mecánicas RPG**:
	- Se escribió `zona_dialogo.gd` para conectarse a nodos `Area2D`. Al colisionar con el Player, lanza automáticamente el diálogo asignado (ej. "dialogo_soldado") y se desactiva sola.
	- **Bloqueo RPG:** Se introdujo una bandera de estado en el `Global` (`en_dialogo`). Mientras esté activa, se deshabilitan las físicas horizontales y los saltos del jugador, regresándolo a su animación Idle para darle enfoque exclusivo a la lectura de diálogos.
	- Transición automática: Se agregó un timer de 4 segundos a `Capitulo1Intro.tscn` para saltar orgánicamente al gameplay.

16. **Mejoras Estéticas y Formato Dinámico**:
	- **Textos de Diálogo Avanzados:** Se migró el motor de lectura a un nodo `RichTextLabel` con la propiedad `BBCode Enabled`. Esto permitió que el archivo `dialogos.json` ahora incorpore etiquetas de formato como `[color=red]`.
	- Integración exitosa de la trama narrativa del Alux Kaan alterando la memoria histórica (monopatín espacial, pizza con piña).
	- **Tamaño dinámico por código:** Se programó un *override* interno (`add_theme_font_size_override`) en `creacion_personaje.gd` para el cuadro `AcceptDialog`, controlando de forma forzada que el tamaño de su tipografía se mantenga en 12 puntos y no distorsione el Pixel Art.

17. **Nueva Escena del Gran Libro de Historia**:
	- Se creó la escena independiente `LibroHistoria.tscn` como nueva interfaz visual para el libro.
	- Se incluyó un fondo color hueso (`ColorRect`) y una imagen a pantalla completa (`libroHistoria.png`).
	- Se limpió el `MenuPrincipal.tscn` eliminando el submenú anidado (`VBox_menu_libro`) y se configuró el botón para hacer una transición directa a esta nueva escena.
	- Se programó `libro_historia.gd` con conexión dinámica a un botón personalizado (`exit_book_btn`) y soporte para la tecla **Esc**, garantizando un retorno seguro al menú principal.

18. **Correcciones UI en Menú Principal**:
	- Se modificaron todos los botones para utilizar `StyleBoxTexture` con la imagen `fondo_botones2.png`.
	- Se configuraron los márgenes internos (`content_margin`) y de textura (`texture_margin` tipo NinePatch) para evitar deformaciones y asegurar que la imagen abarque dinámicamente todo el espacio de los botones.
	- Se añadieron variaciones de opacidad y color a los estados `hover`, `pressed` y `focus` para dar interactividad.
	- Se unificó el color de la fuente de todos los botones al código `#3e2723` (café oscuro) para un mejor contraste.

## 🌊 Otros Sistemas y Cambios Recientes (Actualización)

19. **Gestor Automático de Nivel (`tenoch_manager.gd`)**:
	- Se añadió un gestor para la escena de Tenochtitlán que busca de forma autónoma el `CuadroDialogo` y autoejecuta la línea inicial de `"inicio_tenoch"` para iniciar la narrativa directamente al abrir el nivel.

20. **Sistemas de Agua y Repetición de Entorno**:
	- Se integró el script `water_repeater.gd` que permite clonar horizontalmente animaciones base (como agua o entorno) basándose en una distancia configurada, cubriendo el escenario dinámicamente.
	- Se integraron ejemplos de shaders (`boujie_water_shader`) para renderizados acuáticos o distorsiones visuales.

21. **Escenas de Minijuegos e Interfaces Secundarias**:
	- El proyecto cuenta con la base para el minijuego **Atlas-Bird** (clon estilo Flappy Bird), una escena de rompecabezas (`SlidePuzzle`) y la interfaz de la máquina del tiempo o laboratorio principal (`IU_Maquina.tscn`).

22. **Scripts Individuales de los Aluxes (`alux_1.gd`, `alux_2.gd`, `alux_3.gd`)**:
	- Cada Alux (Kaan, Chaac, etc.) cuenta con su propio script heredando de `CharacterBody2D` y escena independiente, con lógica propia para animar su movimiento (idle, correr izquierda/derecha) separados del jugador principal.

23. **Eliminación Permanente de la Mecánica de Salto**:
	- Se removió por completo toda la lógica de salto (entradas del teclado y la constante `JUMP_VELOCITY`) dentro de `player.gd`, así como de los scripts de los Aluxes (`alux_1.gd`, `alux_2.gd`, `alux_3.gd`). 
	- El jugador y los NPC ahora se desplazan exclusivamente de forma horizontal, ajustándose a la estructura narrativa y mecánicas actuales del entorno.

24. **Límites Dinámicos de la Cámara (Camera2D)**:
	- Se eliminaron los límites fijos en la `Camera2D` dentro de `Player.tscn` para evitar bloqueos en niveles extensos.
	- Se implementó un sistema dinámico usando un nodo visual `ReferenceRect` por nivel. 
	- Se actualizó el `Laboratorio.tscn` añadiéndole el nodo `LimitesCamara` y se creó el script `laboratorio_manager.gd` para leer esos límites e inyectarlos en la cámara, resolviendo el problema de la visibilidad del fondo gris en los bordes del mapa.

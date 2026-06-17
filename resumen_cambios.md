# Resumen de Desarrollo - Los Aluxes que cambiaron la Historia

## ðŸ› ï¸� Cambios Realizados Hoy

1. **Contexto Inicial**:
   - AnÃ¡lisis de la estructura de carpetas de Godot, `MenuPrincipal.tscn`, `Scripts` y el minijuego `Atlas-Bird`.

2. **Nueva Pantalla: "Seleccionar Personaje"**:
   - Se creÃ³ la escena `CreacionPersonaje.tscn` y su controlador `creacion_personaje.gd`.
   - Se vinculÃ³ exitosamente el botÃ³n **"Nueva partida"** del menÃº de laboratorio con esta nueva escena.
   - La pantalla muestra un diseÃ±o recto (sin inclinaciÃ³n), un campo para ingresar nombre y una secciÃ³n de previsualizaciÃ³n.

3. **Selector DinÃ¡mico y Sprites**:
   - Se construyÃ³ un arreglo dinÃ¡mico para la navegaciÃ³n de avatares con botones de izquierda y derecha (`<`, `>`).
   - Se aÃ±adiÃ³ el **Personaje 1** y **Personaje 2** procedentes de la carpeta `Images/Personajes/Personajes_Principales/`.
   - Se codificÃ³ la importaciÃ³n automÃ¡tica de los frames `000` a `003` de la animaciÃ³n **Idle** (respiraciÃ³n).
   - Se arreglÃ³ el problema visual de los pixeles borrosos aplicando `texture_filter = 1` (Nearest) en el Sprite de la interfaz.

4. **Fuentes e Interfaz**:
   - Se probÃ³ una fuente *Pixel Art* (`PressStart2P-Regular.ttf`) cambiando los tamaÃ±os de la interfaz a la mitad. 
   - A peticiÃ³n, se descartÃ³ el tema global y se devolvieron los valores de fuentes masivas y legibles de la configuraciÃ³n de Godot original.

5. **ExplicaciÃ³n TÃ©cnica**:
   - Se explicÃ³ el sistema modular para armar avatares en 2D.
   - Se resolviÃ³ la duda de por quÃ© Godot crea los archivos `.png.import` automÃ¡ticamente para serializar metadatos.

## ðŸš€ Nuevas Implementaciones (Ãšltima SesiÃ³n)

6. **CinemÃ¡tica del PrÃ³logo**:
   - Se creÃ³ la escena `Prologo.tscn` como la nueva escena principal del juego (`main_scene`).
   - Muestra una secuencia de imÃ¡genes tipo novela visual (`Casa`, `Escritorio`, `Pasadizo`, `Laboratorio`) con narraciÃ³n en la parte inferior.
   - Cuenta con transiciones suaves de texto, avance manual (clic/espacio) y un botÃ³n de "Saltar".

7. **ReestructuraciÃ³n del MenÃº Principal**:
   - Se organizÃ³ el botÃ³n "Gran libro de historia" en `MenuPrincipal.tscn` para abrir un nuevo submenÃº anidado (`VBox_menu_libro`).
   - Se moviÃ³ la opciÃ³n de volver a "Ver PrÃ³logo" dentro de este nuevo menÃº, junto con un botÃ³n de retroceso ("Volver").
   - Se aplicaron animaciones (Tween) para que la navegaciÃ³n sea igual de dinÃ¡mica.

8. **Mejoras en CreaciÃ³n de Personaje**:
   - Se mejorÃ³ la previsualizaciÃ³n del avatar: ahora carga los 8 sprites de la carpeta `rotations` para crear una animaciÃ³n continua de giro de 360Â°.
   - **ValidaciÃ³n de nombre:** Se implementÃ³ una alerta en pantalla (`AcceptDialog`) que bloquea el avance si el jugador intenta empezar sin haber escrito su nombre.

9. **IntroducciÃ³n al CapÃ­tulo 1**:
   - Se diseÃ±Ã³ la escena transitoria `Capitulo1Intro.tscn`.
   - Al empezar la aventura desde la selecciÃ³n de personaje, el jugador es llevado a esta pantalla, que muestra el tÃ­tulo "CapÃ­tulo 1" en dorado con sombra negra y el subtÃ­tulo "Alerta en TenochtitlÃ¡n: 1519".
   - Contiene temporalmente un botÃ³n para regresar al menÃº principal.

10. **Redimensionamiento para ResoluciÃ³n 640x360 (Pixel Art)**:
	- Se ajustaron los tamaÃ±os de fuente (usando mÃºltiplos de 8 como 8, 12, 16) en las interfaces para adaptarse a la nueva resoluciÃ³n base.
	- `MenuPrincipal.tscn`: ReducciÃ³n de tÃ­tulos, botones principales y submenÃºs.
	- `CreacionPersonaje.tscn`: Textos, inputs de nombre y botones reducidos. Escala de la previsualizaciÃ³n del avatar ajustada de `(4, 4)` a `(2, 2)`.
	- `Prologo.tscn` y `Capitulo1Intro.tscn`: Textos narrativos, tÃ­tulos y botones de continuar/saltar redimensionados a tamaÃ±os mÃ¡s adecuados.

## ðŸ—¡ï¸� Desarrollo Escena TenochtitlÃ¡n y Sistemas Core (SesiÃ³n Actual)

11. **ConfiguraciÃ³n de la Escena Tenoch**:
	- Se configurÃ³ la escena `Tenoch.tscn` aÃ±adiendo `ParallaxBackgrounds` para el VolcÃ¡n y el Templo con `motion_scale` mÃ­nimos (0.02 y 0.05) para dar la ilusiÃ³n de lejanÃ­a.
	- Se corrigiÃ³ el encuadre de la cÃ¡mara en `Player` ajustando el `zoom` a `(1, 1)` para que encaje exactamente con la resoluciÃ³n de 640x360 del proyecto.

12. **Sistema Global y Persistencia de Datos**:
	- Se programÃ³ el script `global.gd` y se registrÃ³ como un *AutoLoad* en `project.godot`.
	- Ahora el juego almacena en la memoria global quÃ© personaje se eligiÃ³ y transfiere sus rutas de texturas (`ruta_spritesheet` y `ruta_walk`) de forma segura a cualquier nivel.

13. **Sistemas de AnimaciÃ³n Inteligente (Spritesheets)**:
	- **SelecciÃ³n de personaje:** Se cambiÃ³ `creacion_personaje.gd` para leer spritesheets en tiras enteras (ej. 576x64), cortÃ¡ndolas en tiempo real con `AtlasTexture` (9 fotogramas).
	- **Script Reusable (`respirador.gd`)**: Se diseÃ±Ã³ un script que, al ponÃ©rselo a cualquier `Sprite2D`, calcula matemÃ¡ticamente el nÃºmero de fotogramas basÃ¡ndose en la resoluciÃ³n de la textura. Esto reparÃ³ el fallo del soldado (384x64px -> 6 fotogramas) para que no se viera entrecortado.
	- **Player State Machine BÃ¡sica:** `player.gd` ahora alterna inteligentemente entre texturas de estar quieto y caminar segÃºn los controles, revirtiendo la imagen al detenerse.

14. **Motor de DiÃ¡logos por JSON**:
	- Se implementÃ³ un archivo externo estructurado `dialogos.json` que actÃºa como base de datos para la narrativa, permitiendo crear plÃ¡ticas complejas con personaje, texto y retrato sin tocar el cÃ³digo.
	- Se escribiÃ³ `dialogo_manager.gd` que lee y procesa el JSON al vuelo.
	- **Correcciones UI:** 
		- Se resolviÃ³ el difuminado y deformaciÃ³n metiendo el cuadro de diÃ¡logo dentro de un `CanvasLayer`, volviÃ©ndolo inmune a la cÃ¡mara y dejÃ¡ndolo fijo a la pantalla.
		- Se habilitÃ³ *Autowrap* nativo para contener los textos.
		- Se arreglÃ³ el tamaÃ±o monstruoso de la alerta en la creaciÃ³n de personajes (`AcceptDialog`) forzÃ¡ndole cortes de lÃ­nea y lÃ­mites estrictos (200x100px).

15. **Interacciones, Colisiones y MecÃ¡nicas RPG**:
	- Se escribiÃ³ `zona_dialogo.gd` para conectarse a nodos `Area2D`. Al colisionar con el Player, lanza automÃ¡ticamente el diÃ¡logo asignado (ej. "dialogo_soldado") y se desactiva sola.
	- **Bloqueo RPG:** Se introdujo una bandera de estado en el `Global` (`en_dialogo`). Mientras estÃ© activa, se deshabilitan las fÃ­sicas horizontales y los saltos del jugador, regresÃ¡ndolo a su animaciÃ³n Idle para darle enfoque exclusivo a la lectura de diÃ¡logos.
	- TransiciÃ³n automÃ¡tica: Se agregÃ³ un timer de 4 segundos a `Capitulo1Intro.tscn` para saltar orgÃ¡nicamente al gameplay.

16. **Mejoras EstÃ©ticas y Formato DinÃ¡mico**:
	- **Textos de DiÃ¡logo Avanzados:** Se migrÃ³ el motor de lectura a un nodo `RichTextLabel` con la propiedad `BBCode Enabled`. Esto permitiÃ³ que el archivo `dialogos.json` ahora incorpore etiquetas de formato como `[color=red]`.
	- IntegraciÃ³n exitosa de la trama narrativa del Alux Kaan alterando la memoria histÃ³rica (monopatÃ­n espacial, pizza con piÃ±a).
	- **TamaÃ±o dinÃ¡mico por cÃ³digo:** Se programÃ³ un *override* interno (`add_theme_font_size_override`) en `creacion_personaje.gd` para el cuadro `AcceptDialog`, controlando de forma forzada que el tamaÃ±o de su tipografÃ­a se mantenga en 12 puntos y no distorsione el Pixel Art.

17. **Nueva Escena del Gran Libro de Historia**:
	- Se creÃ³ la escena independiente `LibroHistoria.tscn` como nueva interfaz visual para el libro.
	- Se incluyÃ³ un fondo color hueso (`ColorRect`) y una imagen a pantalla completa (`libroHistoria.png`).
	- Se limpiÃ³ el `MenuPrincipal.tscn` eliminando el submenÃº anidado (`VBox_menu_libro`) y se configurÃ³ el botÃ³n para hacer una transiciÃ³n directa a esta nueva escena.
	- Se programÃ³ `libro_historia.gd` con conexiÃ³n dinÃ¡mica a un botÃ³n personalizado (`exit_book_btn`) y soporte para la tecla **Esc**, garantizando un retorno seguro al menÃº principal.

18. **Correcciones UI en MenÃº Principal**:
	- Se modificaron todos los botones para utilizar `StyleBoxTexture` con la imagen `fondo_botones2.png`.
	- Se configuraron los mÃ¡rgenes internos (`content_margin`) y de textura (`texture_margin` tipo NinePatch) para evitar deformaciones y asegurar que la imagen abarque dinÃ¡micamente todo el espacio de los botones.
	- Se aÃ±adieron variaciones de opacidad y color a los estados `hover`, `pressed` y `focus` para dar interactividad.
	- Se unificÃ³ el color de la fuente de todos los botones al cÃ³digo `#3e2723` (cafÃ© oscuro) para un mejor contraste.

## ðŸŒŠ Otros Sistemas y Cambios Recientes (ActualizaciÃ³n)

19. **Gestor AutomÃ¡tico de Nivel (`tenoch_manager.gd`)**:
	- Se aÃ±adiÃ³ un gestor para la escena de TenochtitlÃ¡n que busca de forma autÃ³noma el `CuadroDialogo` y autoejecuta la lÃ­nea inicial de `"inicio_tenoch"` para iniciar la narrativa directamente al abrir el nivel.

20. **Sistemas de Agua y RepeticiÃ³n de Entorno**:
	- Se integrÃ³ el script `water_repeater.gd` que permite clonar horizontalmente animaciones base (como agua o entorno) basÃ¡ndose en una distancia configurada, cubriendo el escenario dinÃ¡micamente.
	- Se integraron ejemplos de shaders (`boujie_water_shader`) para renderizados acuÃ¡ticos o distorsiones visuales.

21. **Escenas de Minijuegos e Interfaces Secundarias**:
	- El proyecto cuenta con la base para el minijuego **Atlas-Bird** (clon estilo Flappy Bird), una escena de rompecabezas (`SlidePuzzle`) y la interfaz de la mÃ¡quina del tiempo o laboratorio principal (`IU_Maquina.tscn`).

22. **Scripts Individuales de los Aluxes (`alux_1.gd`, `alux_2.gd`, `alux_3.gd`)**:
	- Cada Alux (Kaan, Chaac, etc.) cuenta con su propio script heredando de `CharacterBody2D` y escena independiente, con lÃ³gica propia para animar su movimiento (idle, correr izquierda/derecha) separados del jugador principal.

23. **EliminaciÃ³n Permanente de la MecÃ¡nica de Salto**:
	- Se removiÃ³ por completo toda la lÃ³gica de salto (entradas del teclado y la constante `JUMP_VELOCITY`) dentro de `player.gd`, asÃ­ como de los scripts de los Aluxes (`alux_1.gd`, `alux_2.gd`, `alux_3.gd`). 
	- El jugador y los NPC ahora se desplazan exclusivamente de forma horizontal, ajustÃ¡ndose a la estructura narrativa y mecÃ¡nicas actuales del entorno.

24. **LÃ­mites DinÃ¡micos de la CÃ¡mara (Camera2D)**:
	- Se eliminaron los lÃ­mites fijos en la `Camera2D` dentro de `Player.tscn` para evitar bloqueos en niveles extensos.
	- Se implementÃ³ un sistema dinÃ¡mico usando un nodo visual `ReferenceRect` por nivel. 
	- Se actualizÃ³ el `Laboratorio.tscn` aÃ±adiÃ©ndole el nodo `LimitesCamara` y se creÃ³ el script `laboratorio_manager.gd` para leer esos lÃ­mites e inyectarlos en la cÃ¡mara, resolviendo el problema de la visibilidad del fondo gris en los bordes del mapa.

25. **Corrección Definitiva del Sistema de Animación y Autoload (Global)**:
	- Se detectó un fallo crítico en Godot 4 donde el Autoload `Global` no era reconocido debido a su ruta UID interna en `project.godot`. Se reemplazó por su ruta explícita (`res://Scripts/global.gd`), forzando su carga al inicio.
	- **Scripts reescritos desde cero:** `player.gd`, `respirador.gd` y `dialogo_manager.gd` fueron recodificados para ser 100% estables y a prueba de errores de ruta.
	- Se garantizó que el jugador (Player) congele completamente su movimiento (`velocity.x = 0.0`) cuando se abre el cuadro de diálogo leyendo la variable `Global.en_dialogo` de forma segura.
	- **Animaciones automáticas:** Se programó a `player.gd` para que consulte el `Global` y cargue las animaciones del personaje elegido en el menú. Si esto falla, cuenta con un sistema 'Plan B' para cargar al Personaje 1 de forma estática, garantizando que el modelo nunca se quede invisible o sin animaciones.

26. **Mejoras de Cámara y Ajuste de Pantalla (Scaling)**:
	- Se aplicó el sistema de límites dinámicos de cámara a la escena de Tenochtitlán (`tenoch_manager.gd`), permitiendo controlar hasta dónde se desplaza la cámara añadiendo un nodo `ReferenceRect` llamado `LimitesCamara` en el editor.
	- Se forzó el parámetro `window/stretch/aspect="keep"` en `project.godot` para preservar la relación de aspecto 16:9 intacta.
	- Se identificó que el reescalado visual del viewport se activa correctamente en modos Fullscreen y Maximized, pero queda fijado por el editor en modo Windowed estricto para proteger la resolución de desarrollo (720p).

27. **Controles Táctiles y UI**:
	- Creación de la escena `ControlesTactiles.tscn` y su script `controles_tactiles.gd`.
	- Sistema dinámico que oculta los controles táctiles automáticamente cuando la variable global `en_dialogo` está activa.

28. **Compañero Atlas (`atlas.gd`)**:
	- Se configuró el script de comportamiento para Atlas como un `CharacterBody2D`.
	- Implementación de mecánicas de seguimiento al jugador (`follow_distance`) y activación de diálogos automática al entrar a su área.
	- Exclusión de colisiones con otros NPCs para evitar bloqueos durante la navegación.

29. **Nuevos Diálogos y Actualización del Manager**:
	- Modificación de `dialogo_manager.gd` para mejorar la estabilidad y emitir señales (`dialogo_terminado`) esenciales para el flujo del juego.
	- Inserción de nuevos bloques en `dialogos.json`, como `error_maquina`, `encuentro_atlas` e `inicio_tenoch`, expandiendo la narrativa del viaje en el tiempo y las interacciones con el alux Kaan.

30. **Ajustes al Robot Atlas y Diálogos**:
	- Se modificó `atlas.gd` para eliminar la lógica y variables relacionadas con la animación de caminar (`tex_walk`, `hframes_walk`), permitiendo que Atlas use exclusivamente su animación de reposo (`tex_idle`).
	- Se corrigió la lógica de dirección visual (`flip_h`) de Atlas al seguir al jugador, para adaptarse a su *spritesheet* original que mira hacia la izquierda por defecto.
	- Se actualizó masivamente el archivo `dialogos.json` para añadir el retrato de Atlas (`res://Images/Personajes/Atlas/atlas_cara.png`) a todas las intervenciones de "Atlas" y "Atlas (Auricular)", corrigiendo además un diálogo que poseía la imagen equivocada.

31. **Sistema Global de Transiciones de Escena (Fade In/Out)**:
	- Se creó el script `scene_transition.gd` y se registró como *Autoload* en `project.godot` para que siempre esté disponible por encima de cualquier escena.
	- El sistema dibuja un `ColorRect` negro animado usando `Tween` para oscurecer la pantalla ("Fade Out"), cambiar de escena en segundo plano y luego aclararse ("Fade In").
	- Se reemplazaron los cambios bruscos (`get_tree().change_scene_to_file`) por llamadas a `SceneTransition.change_scene()` en `capitulo1_intro.gd` y en los botones **Guardar** y **Volver** de `creacion_personaje.gd`.

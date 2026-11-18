# WildTrace — Registro de cambios

Historial de versiones del addon WildTrace para World of Warcraft 3.3.5a.

## 0.14.2 — Reorganización y validación

- Se reorganiza el código Lua en las carpetas `Core/`, `UI/` y `Data/`, y las texturas en `Brand/`, `Journal/`, `Map/`, `ModelViewer/` y `Portraits/`.
- Se normalizan los nombres y referencias internas a `WildTrace` y `WT`, así como la carpeta del addon y el archivo `WildTrace.toc`.
- La versión se obtiene desde el archivo `.toc`, evitando mantener números de versión duplicados en el código.
- Se normalizan los identificadores de siete criaturas de Mil Agujas al formato `NPC-<CreatureID>`.
- Se retira el código obsoleto de superposición de zonas de patrulla, conservando los datos necesarios para ubicar los marcadores en el mapa.
- Se actualizan las variables guardadas a `WildTraceDB` y `WildTraceCharacterDB`.
- Se limpian referencias y recursos en desuso y se actualizan las rutas de las texturas conservadas.
- Se corrige la llamada `SetRotation` del visor 3D para restaurar la visualización de los modelos.
- Se valida el funcionamiento del registro, los retratos, los filtros, el mapa, las marcas de caza, el visor 3D y la persistencia tras reiniciar el juego. Pruebas superadas en Windows y Linux.

## 0.14.1

- Se amplían los retratos del listado de 35×35 a 45×45 y se ajustan el tamaño y el desplazamiento de las filas.
- Se incorporan nuevos efectos de selección: brillo dorado para la criatura elegida y azul al pasar el cursor.
- Se elimina la ventana informativa emergente del listado de criaturas.
- Se renueva la apariencia de la barra de desplazamiento.
- Se actualizan el fondo del panel central y las ilustraciones del banner superior.
- Se incorporan telones abiertos y cerrados al visor 3D, con ajustes de visibilidad y textos.
- Se añaden 32 retratos nuevos de criaturas (de 95 a 127).
- Se incorporan nuevos recursos gráficos y se retiran texturas antiguas no utilizadas.

## 0.14.0 — EXPLORACION SILENCIOSA Y VISOR 3D POR TROFEOS

- El addon pasa a llamarse Wildtrace: carpeta, archivo .toc y rutas de texturas.
- Comprueba al entrar al mundo la disponibilidad de los modelos del catalogo.
- Escanea cada 0,8 segundos los modelos pendientes de la zona actual, con el registro abierto o cerrado, sin avisos ni alertas de proximidad.
- Muestra un modelo 3D solo si la criatura esta marcada manualmente como cazada y su apariencia esta disponible en la cache del cliente.
- Introduce dos mensajes del visor: bloqueado y no disponible.
- Incorpora textura de ojo tachado (Model3DLocked.tga).
- Conserva giro y zoom con mouse; retira flechas y texto CreatureID.
- Retira visores de precarga y comandos de diagnostico experimentales.
- No modifica la logica de caza, coordenadas, retratos ni filtros.
- El sello de cera CAZADA, las texturas blancas, tamaños y estabilidad de rotacion quedan pendientes.
- El cambio de nombre del addon implicó una adaptación de las claves utilizadas para guardar los datos.

## 0.13.6.5 — MARCADORES DE COORDENADAS DE REINOS DEL ESTE

- Registra las 23 zonas del catálogo en el archivo .toc.
- Integra los 10.092 puntos de coordenadas de las 173 criaturas únicas.
- Soporta formato locations = {{x,y},...} además de {x=...,y=...}.
- Ajusta la clave/nombre interno de Trabalomas al mapa "Hillsbrad".
- Nuevo control "Mostrar en mapa/Ocultar del mapa" por criatura en la ficha.
- Visibilidad persistente por personaje, inicialmente sin criaturas seleccionadas.
- Marcador circular 4x4 con el arte amarillo/negro aprobado por el usuario.
- Reutiliza botones gráficos entre zonas para no acumular marcadores en memoria.
- Tooltips resumidos para evitar miles de líneas en criaturas con muchas posiciones.
- Sin modificar el código del visor 3D, minimapa, patrullas de Kalimdor ni estados de caza.

## 0.13.6.4 — ESTABILIZACION DE VISOR 3D Y FILTRO POR ZONA

- Cambia la camara de retrato (0) a cuerpo completo (1) en el visor 3D, para evitar primeros planos al seleccionar otra criatura y volver.
- Refuerza la deteccion del mapa real del personaje al abrir el registro.
- Agrega nombres alternativos de zonas en ingles y tolerancia a tildes.
- Actualiza la zona mostrada cuando el personaje cambia de zona y el registro esta abierto.
- Comando de diagnostico /wt zona: muestra el nombre real recibido del cliente y la zona seleccionada del catalogo.
- No cambia criaturas, CreatureID, coordenadas, patrullas, texturas, estados guardados, marcadores ni filtros del mapa.
- Pendiente: comprobacion de comportamiento visual dentro de WoW 3.3.5a.

## 0.13.6.3 — Visor 3D del registro (sobre 0.13.6.2)

- Activa un PlayerModel nativo en el espacio 3D reservado del diario.
- Obtiene el CreatureID de npcID/creatureID explícito o de claves NPC-XXXXX.
- Mantiene equivalencias separadas para las 7 claves internas antiguas de Mil Agujas.
- Permite girar el modelo con dos botones en el panel; muestra mensaje si falta ID.
- No importa el Excel en revisión, ni modifica zonas, patrullas, texturas o estados guardados.
- SetCreature puede necesitar una criatura en caché en el cliente 3.3.5a.
- No probado dentro de un cliente WoW real; requiere comprobación visual in-game.

## 0.13.6.2 — Corrección de casillas del mapa (sobre 0.13.6.1)

- Se reemplazan los controles UICheckButtonTemplate por casillas autocontenidas usando las texturas nativas WHITE8X8.
- Se dibuja el recuadro siempre y una marca dorada cuando la opción está activa.
- Se conserva el estado guardado, los cuatro filtros y todas las funciones del addon.
- No se cambia el diseño del registro ni la geometría de las patrullas.

## 0.13.6.1 — Registro de proporciones Blizzard (basado en 0.13.6)

- ZIP COMPLETO del addon, no parche parcial; conserva mapa, zonas, patrullas, datos, filtros, marcadores, minimapa, menús y texturas de 0.13.6.
- Registro ajustado a 703 x 606 unidades de interfaz, columna lateral de 260, filas de 46.
- Dos columnas reajustadas: filtros, búsqueda, lista y paginación a la izquierda; retrato, ficha, estado y reserva 3D a la derecha.
- Diez filas por página, desplazamiento vertical adaptado al espacio disponible.
- Ajuste proporcional únicamente en pantallas cuya zona útil no alcance 703 x 606.
- No se modifica ningún SavedVariable ni se reemplaza el espacio 3D por un falso modelo.
- Basado exclusivamente en el ZIP 0.13.6 facilitado por el usuario, sin presumir cambios posteriores.

## 0.13.6

- Registro rediseñado sobre controles interactivos de WoW 3.3.5a según la referencia visual aprobada.
- Cabecera oscura con emblema circular y título Wildtrace - Registro de criaturas.
- Lista desplazable con iconos por criatura, selección dorada, búsqueda y filtros conservados.
- Ficha derecha con marco de dragón plateado, nombre, nivel, clasificación, tipo y descripción.
- Botón rojo Marcar como cazada en el panel izquierdo, vinculado al estado guardado.
- Zona negra reservada para el visor 3D; se oculta la nota Aún no conseguida al marcar cazada.
- Ilustraciones provisionales para siete criaturas de Mil Agujas, extraídas del boceto aprobado; no son retratos oficiales ni modelos reales.
- Sin cambios en las formas cóncavas, coordenadas, filtros del mapa, iconos del minimapa ni datos persistentes.

## 0.13.5

- Registro de criaturas con cabecera tipo diario de monturas y medallón Wildtrace.
- Panel izquierdo de búsqueda/filtros/listado de 10 criaturas y contador de la zona.
- Ficha derecha con fondo propio de bestiario, estado de caza y espacio reservado para visor 3D.
- Panel de filtros del mapa ahora en UIParent con una capa independiente y opaca.
- Sin cambios en datos, zonas de patrulla, marcadores, comandos ni SavedVariables.

## 0.13.4 — (prueba)

- Registro rediseñado en dos columnas (lista izquierda + ficha derecha), estética oscura/dorada.
- Emblema circular de Wildtrace en cabecera; zona de modelo 3D reservada para versión futura.
- Selección con clic, menú anterior accesible con clic derecho y acciones de caza en ficha.
- Conserva búsqueda, filtros, diez registros por página y estados por personaje.
- Panel de filtros sobrepuesto al mapa en estrato FULLSCREEN_DIALOG para impedir elementos del mapa sobre su texto.
- Tooltip del botón: Wildtrace, versión y Filtros de Wildtrace.
- Texturas cóncavas de patrullas y datos sin modificaciones.

## 0.13.3 — (prueba)

- Restauradas las cinco zonas concavas previamente existentes (Bjarn y cuatro criaturas de Mil Agujas).
- Relleno azul translucido y borde continuo, sin sustituir las zonas por circulos.
- Resto de funciones sin cambios respecto de 0.13.2.

## 0.13.2 — (prueba)

- Botón cuadrado del mapa reducido a 29 px y desplazado ligeramente hacia abajo.
- Botón del minimapa: logo Wildtrace y tooltip Wildtrace.
- Zonas de patrulla existentes: representación circular azul semitransparente con borde suave, aproximada (no una ruta exacta).
- Registro: separación visual de Nivel/clasificación y Tipo; título Estado de caza.
- Sin cambios en filtros, paginación ni lógica de detección de zona.

## 0.13.1 — (prueba)

- Menú de criatura con altura adaptable: el botón de caza no se superpone a títulos de tres líneas.
- Botón de filtros clicable en la capa del mapa, con textura cuadrada suministrada por el usuario.
- Panel de filtros abre hacia dentro del mapa desde la esquina 98/2.
- Registro detecta zonas localizadas con artículos (p. ej. Las Mil Agujas).
- /wt, criaturas y geometrías de patrulla existentes sin cambios.

## 0.13.0

- /wt, botón de huella en esquina superior derecha del mapa, selección automática de zona al abrir registro, ajuste de línea de Bjarn y cuatro patrullas de Mil Agujas. Tres patrullas pendientes de coordenadas completas.

---

*En el archivo original, las versiones 0.12.0 y anteriores aparecen bajo el encabezado «CreatureTrackerDev - CHANGELOG».*

## 0.12.0 — CORRECCIONES VISUALES Y MIL AGUJAS

- Ajusta la capa y el nivel del botón de opciones del mapa para que no fuerce la capa DIALOG por encima de otras ventanas. El panel de opciones usa la misma capa base.
- Reduce el grosor del contorno de la zona piloto de Bjarn, conservando el relleno y la geometría de la zona.
- Incorpora Mil Agujas (Kalimdor) con siete criaturas, sus datos y coordenadas de referencia.
- Integra las descripciones acordadas en la columna Descripción del registro.
- Identifica explícitamente como exótica la domesticabilidad del Devastador silítido en el registro.
- Mantiene /ct sin cambios; el cambio a /wt queda reservado para el renombrado definitivo.
- La paginación no se modifica y sigue pendiente de prueba con más de diez registros.

## 0.11.0 — ZONA DE PATRULLA PILOTO PARA BJARN

- Agrega una zona de patrulla piloto para Bjarn (NPC-1130), basada en 63 muestras de coordenadas proporcionadas por el usuario.
- El contorno utiliza una envolvente cóncava (alpha shape), radio 2.0, con 22 vértices.
- El área se dibuja como una capa semitransparente y un borde azul sobre el mapa de Dun Morogh.
- El marcador de Bjarn se coloca en el centroide de la zona (58.6, 58.2).
- Agrega un filtro independiente para mostrar/ocultar zonas de patrulla.

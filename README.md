UTN - Facultad Regional Buenos Aires - Materia Paradigmas de Programación

## Equipo de desarrollo:

- Arellano, Ariel Iván
- Davenheimer, Emerson Javier
- Di Bennardo, Juan Ignacio
- Porzolis Requena, Alexis Eduardo

## Introducción

WoToDe es un juego de tipo tower defense, él cual consiste en defender nuestro núcleo vital de los enemigos que buscan destruirlo, para ello podemos crear torres, con distintos efectos, para cubrir nuestra razón de existir.

## Capturas
![Imagen de la pantalla principal del juego WoToDe](captura_pantalla-principal.png)
*Pantalla principal*

![Modo construcción de torres](captura_construccion.png)
*Etapa de construcción*

![Enemigo avanzando en el mapa y siendo ejecutado](captura_enemigo.png)
*Enemigos en acción*

![Enemigos y torres en acción](captura_jugabilidad.png)

*Interacción enemigos-torres*

![Nivel completado atisfactoriamente](captura_victoria.png)
*¡Victoria!*

## Reglas de Juego / Instrucciones

### Instrucciones del juego
> Una vez iniciado WoToDe, el jugador se encontrará en la página principal, dónde debe escoger el nivel que desea jugar. A partir de allí, se encontrará con las siguientes fases:
>
>> Fase de selección de nivel: debe presionar la tecla del nivel que quiere jugar.
>>
>> Fase de construcción: puede colocar tantas torres según la cantidad de monedas que disponga (puede ver el costo de cada torre en el menú lateral).
>>
>> Fase de ejecución de ronda: los enemigos avanzarán por el camino marcado con el objetivo de llegar al núcleo.
>>
>> Fase fin de ronda: cada vez que finalice una ronda, el jugador recibirá oro para poder seguir construyendo más torres.

### Tipos de enemigos
![Imágen del enemigo básico I](./assets/enemy_basic_alive_0.png "Imagen del enemigo común I") Enemigo común I: puede recibir daño de cualquier torre.

![Imágen del enemigo básico II](./assets/enemy_basic_alive_1.png "Imagen del enemigo común II") Enemigo común II: puede recibir daño de cualquier torre.

![Imágen del enemigo básico III](./assets/enemy_basic_alive_2.png "Imagen del enemigo común III") Enemigo común III: puede recibir daño de cualquier torre.

![Imágen del enemigo básico IV](./assets/enemy_basic_alive_3.png "Imagen del enemigo común IV") Enemigo común IV: puede recibir daño de cualquier torre.

![Imágen del enemigo con armadura](./assets/enemy_armored_alive.png "Imagen del enemigo con armadura") Enemigo con armadura: únicamente la torre perforante le puede hacer daño.

![Imágen del enemigo explosivo](./assets/enemy_explosive_alive.png "Imagen del enemigo explosivo") Enemigo explosivo: al ser destruido explota y hace daño en área a los demás enemigos.

### Tipos de torres
![Imágen de la torre básica](./assets/tower_basic_idle.png "Imágen de la torre básica") Torre básica: hace daño a los enemigos comunes.
![Imágen de la torre ralentizante](./assets/tower_slowing_idle.png "Imágen de la torre ralentizante") Torre ralentizante: ralentiza al enemigo atacado.
![Imágen de la torre perforante](./assets/tower_piercing_idle.png "Imágen de la torre perforante") Torre perforante: es la única que puede hacer daño a los enemigos con armadura.

**¿Cómo construyo las torres?**
Primero debe presionar la tecla "Q", luego seleccionar la torre que quiere colocar (Tecla #1, #2 o #3) y finalmente tocar la tecla de "Espacio" para confirmar la construcción.

**¿Cómo ganar?**
Pasar todas las rondas antes de que el nucleo se quede sin vida.

**Puedo seguir construyendo torres mientras aparecen los enemigos**
Si.

### Controles:

| Tecla  | Acción |
| ------------- |:-------------:|
| W-A-S-D      | Movimientos del personaje     |
| Q     |  Ver rango de las torres    |
| 1     |  Cambiar vista a torre básica |
| 2      |  Cambiar vista a torre ralentizante |
| 3      |  Cambiar vista a torre perforante |
| Espacio      | Costruir torre |
| S      | Vender torre  |
| E      | Iniciar o avanzar una ronda |
| R      | Reiniciar el juego  |

## Explicaciones teóricas y diagramas

- [Aplicación de conceptos teóricos](./aplicacionTeorica.md)





## Explicación breve del juego
**WoToDe** es un juego de tipo tower defense, él cual consiste en defender nuestro núcleo vital de los enemigos que quieren destruirlo, para ello podemos crear torres, con distintos efectos, para cubrir nuestra razón de existir. Además, según el personaje elegido, tendremos poderes adicionales.


## Objetos
- player
- tdGame

## Clases
- Tower
- Round
- Stage
- Enemy

## Subclases
- BasicEnemy
- ArmoredEnemy
- ExplosiveEnemy
- BasicTower
- PiercingTower
- SlowingTower

## Interfaz
- Attack

## Conceptos del paradigma
- Herencia
- Objetos vs Clases
- Polimorfismo
- Encapsulamiento
- Responsabilidades

## ¿Dónde se aplicó cada concepto?

### Herencia
Creamos las superclases **Enemy** y  **Tower** para definir la base de lo que es ser un enemigo o una torre. Y luego creamos las clases, aplicando herencia, para tener diversos tipos de enemigos y de torres con cualidades únicas. De esa forma evitamos repetir lógica y, además, tenemos más libertad de desarrollar nuevos enemigos y torres.

### Objetos vs Clases
Los componentes **player** y **tdGame** los creamos como objetos, ya que solo necesitabamos una instancia de cada uno para todo el proceso del juego. Se podría decir que con una instancia de cada uno resolvemos todas las necesidades que teníamos, las cuáles eran poder tener un tablero dónde todo va a suceder y tener un jugador que permita tener la interacción con el juego.
Mientras que **Round**, **Stage**, **Tower**, **BasicTower**, **PiercingTower**, **SlowingTower**, **Enemy**, **BasicEnemy**, **ArmoredEnemy** y **ExplosiveEnemy** fueron creados como clases dado que necesitabamos más de una instancia de esos componentes para poder darle sentido a nuestro juego. Para que se entienda mejor, el juego consiste en construir cierta cantidad de torres(según el oro total) en cada nivel y van a ir apareciendo un número de enemigos en cada ronda hasta completar el total de las mismas que tiene un nivel. Ante la necesidad de diversidad de un tipo de componente ya sea para tener más dinamismo funcional u organizativo es que se justifica el uso de estas clases.

### Polimorfismo
Aplicamos este concepto de dos maneras distintas:
- A través de una interfaz
En este caso, usamos polimorfimo para poder tener distintos tipos de ataques e internamente cada uno haga cosas distintas cosas con lo que tiene a disposición (atributos dependiendo de la torre), pero que mantengan la esencia(un contrato) de realizar daño  un enemigo. Más concretamente, las instancias **basicAttack**, **piercingAttack** y **slowingAttack** saben responder el mensaje de **doDamage(damage, enemy)** que le envía cualquier torre. Aunque todos tienen el mismo método, cada uno resuelve la forma de hacer daño de forma interna:
```
object basicAttack {
  method doAttack(damage, enemy) {
    enemy.receiveBasicAttack(damage)
  }
}
```
```
object piercingAttack {
  method doAttack(damage, enemy) {
    enemy.receivePiercingAttack(damage)
  }
}
```
```
object slowingAttack {
  method doAttack(damage, enemy) {
    enemy.receiveSlowingAttack(damage)
  }
}
```

- A través de la herencia
En este otro caso, se dió más naturalmente el polimorfismo, ya que cuando se instancien las **basicTower**, **piercingTower** y **slowingTower** heredarán el método **attackInRange** de la super clase **Tower**. 

### Encapsulamiento
Como queríamos que todas nuestras clases y objetos pudieran ser los únicos en modificar sus atributos, todos cuentan con métodos para que otras clases/componentes les soliciten lo que realmente saben hacer y que se respete la privacidad de sus datos. Por ejemplo, de la clase enemigo *(ver imágen 1)* lo que queremos es que sepas responder a los mensajes de mostrar su imagen, aparecer, desaparecer o moverse con los métodos que tiene, pero no queremos que esas mismas instancias modifiquen el comportamiento interno de este enemigo; debe ser suficiente conque responda a lo que sabe hacer.

### Responsabilidades / Acoplamiento
Buscamos que las interacciones entre objetos/clases sean lo menos acoplados posibles. Es decir, que como la torre debe hacerle daño a un enemigo, entonces la torre simplemente tiene el método **doDamage(damage, enemy)** que le pide al enemigo que reciba el daño (**receiveDamager(power)**) correspondiente al daño de la misma. Logrando así, bajo acoplamiento al no modificar directamente la vida al enemigo desde la instancia de la torre.
Lo mismo sucede cuando el **player** quiere poner una torre en una posición específica. Lo que sucede es que éste objeto, usando el método **addTower(tower)** le pide a la torre que aparezca en esa posición con **tower.spawn()** y ésta se encarga de aparecer, o no. Así cada uno se limita a responder mensajes que entienden y hacer solo sus tareas, sin importar como se resuelva el pedido del otro lado. Esto facilita futuros cambios, como podría ser el cómo aparece la torre.

# Diagramas
![Diagrama de Gameflor](diagrama_gameflow.png)
*(Imagen 1)*

![Diagram de Tower y Enemy](diagrama_tower-enemy.png)
*(Imagen 2)*

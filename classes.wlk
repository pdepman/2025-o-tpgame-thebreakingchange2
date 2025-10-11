class HudTile {
	var property position
	const hudPosition
	
	method image() = "hud_bg_"+ hudPosition +".png"
}

class BasicEnemy {
	var pathPosition = 0
	var property position
	const path
	var hp
	var power
	var speed
	var image = "enemy_basic.png"
	method image() = image
	
	method position() = position
	method pathPosition() = pathPosition 
	
	method goForward() {
		pathPosition = path.length().min(pathPosition + speed)
		position = path.roadAt(pathPosition).position()
	}
	
	method damage(structure) {
		structure.receiveDamage(power)
		self.disappear()
	}
	
	method disappear() {
		game.removeVisual(self)
		game.removeTickEvent("moveEnemy")
	}
	
	method receiveDamage(damage) {
		hp -= damage
		image = "enemy_armored.png"
	}
	
	method attack() {
		
	}
}


//Detecta a un enemigo en el rango y lo encola (hay que ver que detecte a más de uno)
//Dispara al enemigo en el rango (hay que sacarlo de la cola y se vuelva a encolar en la prox detección)
//Finalmente el objetivo es cumplir con que ataque al enemigo que esté más avanzado en el PATH

class Tower {
	var property position
	var power
	var attackSpeed
	var range
	const enemiesInRange = []

	method image()
	
	method show() {
		game.addVisual(self)
		game.sound("sfx_tower_spawn.mp3").play()
		//status = "idle"
	}

	method detectEnemies(enemy) {
		//console.println(position.distance(enemy.position()).truncate(0))
		if (position.distance(enemy.position()) <= range) {
			enemiesInRange.add(enemy)
			console.println(enemiesInRange.size())
			self.doAttack(enemiesInRange.get(0))
		}
	}

	method doAttack(enemy) {
		game.sound("sfx_hit_basic.mp3").play()
		enemy.receiveDamage(power)

		// if(enemiesInRange.size() != null){
		// 	enemiesInRange.pathPosition().max().receiveDamage(power)
		// acá debería borrar a todos los enemigos de la cola
		// enemiesInRange.clear()
		// }
		
		//status= "attacking"
	}
}
class BasicTower inherits Tower{
	override method image() = "tower_basic.png"
}

class PiercingTower inherits Tower{
	override method image() = "tower_piercing.png"
}

class SlowingTower inherits Tower{
	override method image() = "tower_slowing.png"
}

class BasicPlayer {
	var property towers = []
	var property position
	
	method image() = "player.png"
	
	method addBasicTower() {
		towers.add(
			new BasicTower(
				position = position,
				power = 10,
				attackSpeed = 1000,
				range = 2
			)
		)
		towers.last().show()
	}

	method addPiercingTower() {
		towers.add(
			new PiercingTower(
				position = position,
				power = 10,
				attackSpeed = 1000,
				range = 2
			)
		)
		towers.last().show()
	}

	method addSlowingTower() {
		towers.add(
			new SlowingTower(
				position = position,
				power = 10,
				attackSpeed = 1000,
				range = 2
			)
		)
		towers.last().show()
	}
}

class Stage {
	const path
	const core
	var resources

	method load() {
		path.beDisplayed()
		core.beDisplayed()
	}
	method clear() {
		// Limpio el path de la pantalla
		// Limpio coro de la pantalla
		// Limpio el personaje de la pantalla UFF PODRIA USAR EL PERSONAJE PARA SELECCIONAR EL NIVEL
		// Vuelvo todas las variables a su estado inicial
	}
	
	method core() = core

	method reset() {
		self.clear()
		self.load()
	}

	method addResources(amount){
		resources += amount
		game.sound("sfx_resources_added.wav").play()
	}

	method substractResources(amount){
		resources -= amount
	}

	method resources() = resources

	// method startNextRound() {
	// 	currentRoundIndex += 1
	// 	rounds.get(currentRoundIndex).start()
	// }	

	// method addTower(tower) {
	// 	towers.add(tower)
	// }

}

class Path {
	const roads
	method length() = roads.size()
	method roadAt(indexNumber) = roads.get(indexNumber)
	method beDisplayed() {
	  roads.forEach({road => road.beDisplayed()})
	}
}


class Road {
	const property position
	
	method image() = "tile_road.png"
	
	method beDisplayed() {
		game.addVisual(self)
	}
}

class Core {
	var property position
	var hp
	
	method image() = "core.png"
	
	method hp() = hp

	method receiveDamage(damage) {
		hp -= damage
	}

	method beDisplayed() {
		game.addVisual(self)
	}
}


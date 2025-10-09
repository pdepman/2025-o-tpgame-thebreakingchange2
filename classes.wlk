class HudTile {
	var property position
	
	method image() = "bg_menu.png"
}

class BasicEnemy {
	var pathPosition = 0
	var property position
	const path
	var hp
	var power
	var speed
	
	method image() = "enemy.png"
	
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
	}
	
	method attack() {
		
	}
}

class BasicTower {
	var property position
	var power
	var attackSpeed
	var range
	
	method image() = "tower.png"
	
	method show() {
		game.addVisual(self)
	}
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
	
	method reset() {
		self.clear()
		self.load()
	}

	method addResources(amount){
		resources += amount
	}

	method substractResources(amount){
		resources -= amount
	}

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
	
	method image() = "road.png"
	
	method beDisplayed() {
		game.addVisual(self)
	}
}

class Core {
	var property position
	var hp
	
	method image() = "core.png"
	
	method receiveDamage(damage) {
		hp -= damage
	}

	method beDisplayed() {
		game.addVisual(self)
	}
}


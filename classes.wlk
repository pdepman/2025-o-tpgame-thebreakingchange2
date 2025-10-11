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
	
	method image() = "enemy_basic.png"
	
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

//atacar a punto fijo
/*atacar a bichos (primero escanea, ve enemigos en su rango, de todos los que está en su rango ataca
al que más avanzado está en el PATH)
FUNCIÓN PARA VER LA DISTANCIA ENTRE COSAS, CHECK WOLLOK GAME*/

class Tower {
	var property position
	var power
	var attackSpeed
	var range
	
	method image()
	
	method show() {
		game.addVisual(self)
		game.sound("sfx_tower_spawn.mp3").play()
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
	const rounds
	var resources
	var roundIndex = 0


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

	method currentRound() = rounds.get(roundIndex)

	method startCurrentRound() {
		self.currentRound().start()
	}

	method advanceRoundIndex() {
		roundIndex += 1
	}

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

class Round {
	const enemies
	const resourcesReward
	var enemiesIndex = 0
	const tickId = "round-" + self.identity() + "control"

	method resourcesReward() = resourcesReward

	method start() {
		game.onTick(1000, tickId, { self.spawnNextEnemy() })
	}
	method spawnNextEnemy() {
		self.nextEnemy().spawn()
		self.advanceEnemiesIndex()
	}
	method nextEnemy() = enemies.get(enemiesIndex)
	method advanceEnemiesIndex() { enemiesIndex += 1 }
	method end() {
		game.removeTickEvent(tickId)
	}
}
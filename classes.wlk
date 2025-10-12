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
		image = "enemy_basic_attacked.png"
	}
	
	method attack() {
		
	}
}

class Tower {
	var property position
	var power
	var attackSpeed
	var range
	var enemiesInRange = []

	method image()
	
	method show() {
		game.addVisual(self)
		game.sound("sfx_tower_spawn.mp3").play()
	}
	method attackEnemy(enemies) {
		var target = self.detectEnemyToAttack(enemies)
		self.doAttack(target)
		//self.doAttack(self.detectEnemyToAttack(enemies))
	}

	method detectEnemyToAttack(enemies) {
		var enemiesFiltered = enemies.filter({ enemy => position.distance(enemy.position()) <= range }) 
		return enemiesFiltered
			.fold(enemiesFiltered.get(0), { enemyWithMaxPath, otherEenemy =>
				if (otherEenemy.pathPosition() > enemyWithMaxPath.pathPosition()) otherEenemy else enemyWithMaxPath
			})
	}

	method doAttack(enemy) {
			game.sound("sfx_hit_basic.mp3").play()
			enemy.receiveDamage(power)
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

	method towersIsEmpty() = towers.isEmpty()
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


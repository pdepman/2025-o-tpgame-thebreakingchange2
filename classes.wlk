class MenuTile {
	var property position
	method image() = "bg_menu.png"
}

class BasicEnemy{
	var pathPosition = 0
	var property position
	const path
	var hp
	var power
	var speed

	method image() = "enemy.png"

	method goForward() {
		pathPosition = path.size().min(pathPosition + speed) 
		position = path.get(pathPosition).position()
	}

	method damage(structure){
		structure.receiveDamage(power)
		self.disappear()
	}

	method disappear() {
	  	game.removeVisual(self)
	  	game.removeTickEvent("moveEnemy")
	}

	method receiveDamage(damage) {
		hp = hp - damage
	}
}

class Road {
	var property position
	method image() = "road.png"
}

class Core {
	var property position
	var hp

	method image() = "core.png"

	method receiveDamage(damage) {
		hp = hp - damage
	}
}
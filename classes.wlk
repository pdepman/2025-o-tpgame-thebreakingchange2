import objects.*
class HudTile {
	var property position
	const hudPosition
	
	method image() = "hud_bg_"+ hudPosition +".png"
}

class Enemy {
    var pathPosition = 0
    var property position
    const path
    var hp
    var power
    var speed
	const tickName = "moveEnemy_" + self.identity()

    method spawn() {
		enemiesRegistry.add(self)
        game.addVisual(self)
        game.onTick(speed * 1000, tickName, { self.goForward() })
    }

    method despawn() {
		enemiesRegistry.remove(self)
    	game.removeVisual(self)
    	game.removeTickEvent(tickName)   // <--- uso la variable que ya definimos en spawn()
}

    method goForward() {
        pathPosition = path.length().min(pathPosition + 1)
        position = path.roadAt(pathPosition).position()

        // Si llegó al final, hace daño al core
        if (pathPosition == path.length() - 1) {
            self.doDamage(path.core())
        }
    }

    method doDamage(core) {
        core.receiveDamage(power)
        self.despawn()
    }

	method receiveDamage(amount) {
		hp -= amount
	}

    method receiveAttack(attack)

	method beSlowed(){
		speed = (speed / 2).max(0)
	}

    method image()
}

class BasicEnemy inherits Enemy {
    override method image() = "enemy_basic.png"
    
    override method receiveDamage(attack)  {
        self.receiveDamage(attack.damage())
        if (attack.isSlowing()) {
            self.beSlowed()
        }
        if (hp <= 0) self.despawn()
    }
}

class ArmoredEnemy inherits Enemy {
    override method image() = "enemy_armored.png"

    override method receiveDamage(attack) {
        if (attack.isPiercing()){
			self.receiveDamage(attack.damage())
		}
        if (attack.isSlowing()) {
            self.beSlowed()
        }
        if (hp <= 0) self.despawn()
    }
}

class ExplosiveEnemy inherits Enemy {
    
	var radius = 2
	
    override method receiveDamage(attack)  {
        self.receiveDamage(attack.damage())
        if (attack.isSlowing()) {
            self.beSlowed()
        }
        if (hp <= 0){
			if (attack.isPiercing()){
				self.blowUp()
			} else {
				self.despawn()		
			}
		} 
    }

    method blowUp() {
        enemiesRegistry.all()
            .filter({ e => e != self && position.distance(e.position()) <= radius })
            .forEach({ e => e.receiveDamage(power) })

        self.despawn()
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
	var enemiesInRange = []
	var attack

	method image()
	
	method show() {
		game.addVisual(self)
		game.sound("sfx_tower_spawn.mp3").play()
	}
	method attackEnemy(enemies) {
			var target = self.detectEnemyToAttack(enemies)
			if(target!=null){
				self.doAttack(target)
			}
	}

	method detectEnemyToAttack(enemies) {
		var enemiesFiltered = enemies.filter({ enemy => position.distance(enemy.position()) <= range }) 
		if(enemiesFiltered.isEmpty()){
			return null
		}
		return enemiesFiltered
			.fold(enemiesFiltered.get(0), { enemyWithMaxPath, otherEenemy =>
				if (otherEenemy.pathPosition() > enemyWithMaxPath.pathPosition()) otherEenemy else enemyWithMaxPath
			})
	}

	method doAttack(enemy) {
	enemy.receiveAttack(attack)
	}

}


class BasicAttack {
	const tower

	method isPiercing() = false
	method isSlowing() = false

	method damage() = tower.power()
}

class PiercingAttack {
	method isPiercing() = true
	method isSlowing() = false
}

class SlowingAtacck {
	method isPiercing() = false
	method isSlowing() = true

	method damage(tower) = tower.power() * 0.5
}

/*
Se revisará cuando el branch de enemy 
 class ArmoredEnemy inherits Enemy {
	const tick_id = "enemy_movement" + self.identity()
	method spawn(){
		addvisual(self)
		game.tick(1000, "enemy_movement" + self.identity() , self.goForward())
	}


	method receiveAttack(attack) {
		if (attack.isPiercing()) {
			self.receiveDamage(attack.damage())
		}
	}

	method receiveDamage(amount)
} */



class BasicTower inherits Tower{
	override method image() = "tower_basic.png"

	method doAttack(enemy) {
		enemy.receiveAttack(self)	
	}
}


class PiercingTower inherits Tower{
	method doAttack(enemy) {
	enemy.receiveDamage(power)
	}
	override method image() = "tower_piercing.png"
}

class SlowingTower inherits Tower{
	method doAttack(enemy) {
	enemy.receiveDamage(power)
	}
	override method image() = "tower_slowing.png"
}

class BasicPlayer {
	var property towers = []
	var property position
	
	method image() = "player.png"
	
	method addBasicTower() {
		towers.add(
			new BasicTower(
				attack = 10,
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
				attack = 10,
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
				attack = 10,
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


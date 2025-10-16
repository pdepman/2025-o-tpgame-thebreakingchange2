import models_game.*

class Enemy {
    var pathPosition = 0
    var property position
    const path
    var hp
    var power
    var speed
	const tickName = "moveEnemy_" + self.identity()

	method pathPosition() = pathPosition

    method hp() = hp

    method speed() = speed

    method spawn() {
		enemiesRegistry.add(self)
        game.addVisual(self)
        game.onTick(1000/speed, tickName, { self.goForward() })
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
		game.sound("sfx_hit_basic.mp3").play()
		if (self.isDead()){
            self.die()
		} 
	}

    method receiveBasicAttack(damage)

	method receivePiercingAttack(damage)

	method receiveSlowingAttack(damage)

	method beSlowed(){
		game.sound("sfx_hit_slowing.wav").play()
		speed = (speed / 2).max(0)
	}

    method die() {
        tdGame.currentStage().currentRound().discountEnemy()
        self.despawn()

    }

	method isDead() = hp <= 0

    method image()
}

class BasicEnemy inherits Enemy {
    override method image() = "enemy_basic.png"
    
    override method receiveBasicAttack(damage){
		self.receiveDamage(damage)
	}

	override method receivePiercingAttack(damage){
		self.receiveDamage(damage)
	}

	override method receiveSlowingAttack(damage){
		self.receiveDamage(damage)
		self.beSlowed()
	}
}

class ArmoredEnemy inherits Enemy {
    override method image() = "enemy_armored.png"

	    override method receiveBasicAttack(damage){
		game.sound("sfx_hit_resisted.wav").play()
	}

	override method receivePiercingAttack(damage){
		self.receiveDamage(damage)
	}

	override method receiveSlowingAttack(damage){
		self.receiveDamage(0)
		self.beSlowed()
	}
}

class ExplosiveEnemy inherits Enemy {
	const radius = 2

	override method image() = "enemy_explosive.png"
	
    override method receiveBasicAttack(damage){
		self.receiveDamage(damage)
	}

	override method receivePiercingAttack(damage){
		self.blowUp()
	}

	override method receiveSlowingAttack(damage){
		self.receiveDamage(damage)
		self.beSlowed()
	}

    method blowUp() {
        hp = 0
        enemiesRegistry.all()
            .filter({ e => e != self && position.distance(e.position()) <= radius })
            .forEach({ e => e.receiveDamage(power) })
        self.despawn()
    }

}

object enemiesRegistry {
    var enemies = []

    method add(e) {
        enemies.add(e)
    }

    method remove(e) {
        enemies.remove(e)
    }

    method all() = enemies
}
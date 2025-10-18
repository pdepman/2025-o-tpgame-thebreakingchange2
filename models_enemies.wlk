import models_game.*

class Enemy {
    var pathPosition = 0
    var property position = game.at(99, 99)
    var hp
    const power
    var speed
    var tickEvent = game.tick(1000, {}, false)

	method pathPosition() = pathPosition

    method hp() = hp

    method speed() = speed

    method tickMs() = 1000/speed

    method spawn(stage) {
		enemiesRegistry.add(self)
        game.addVisual(self)
        tickEvent = game.tick(self.tickMs(), {self.goForward(stage)}, true)
        tickEvent.start()
    }

    method despawn() {
		enemiesRegistry.remove(self)
    	game.removeVisual(self)
    	tickEvent.stop()
	}

    method goForward(stage) {
        position = stage.path().get(pathPosition).position()

        if (self.isAtTheEndOfThePath(stage.path())) {
            self.doDamage(stage.core())
        }
        
        pathPosition = stage.path().size().min(pathPosition + 1)
    }

    method isAtTheEndOfThePath(path) = path.last().position() == position

    method doDamage(damageable) {
        damageable.receiveDamage(power)
        self.die()
    }

	method receiveDamage(amount) {
		hp -= amount
        if (amount > 0 ) game.sound("sfx_hit_basic.mp3").play()
		if (self.isDead()){
            self.die()
		} 
	}

    method receiveBasicAttack(damage)

	method receivePiercingAttack(damage)

	method receiveSlowingAttack(damage)

	method beSlowed(){
		game.sound("sfx_hit_slowing.wav").play()
		speed = 0.25.max(speed / 2)
        tickEvent.interval(self.tickMs())
	}

    method die() {
        hp = 0
        tdGame.currentStage().currentRound().discountEnemy()
        self.despawn()
    }

	method isDead() = hp <= 0

    method image()
}

class BasicEnemy inherits Enemy {
    override method image() = "enemy_basic_" + hp.toString() +".png"
    
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
        enemiesRegistry.all()
            .filter({ e => e != self && position.distance(e.position()) <= radius })
            .forEach({ e => e.receiveDamage(power) })
        game.sound("sfx_alf_pop.wav").play()
        self.die()
    }

}

object enemiesRegistry {
    const enemies = []

    method add(e) {
        enemies.add(e)
    }

    method remove(e) {
        enemies.remove(e)
    }

    method all() = enemies
}
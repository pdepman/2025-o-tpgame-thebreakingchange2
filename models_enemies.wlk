import models_game.*

class Enemy {
    var pathPosition = 0
    var property position = game.at(99, 99)
    var hp
    const power
    var speed
    var movementTick = null
    const name
    var status = "alive"
    var text = ""

    method image() = "enemy_" + name + "_" + status + ".png"

    method text() = text

	method pathPosition() = pathPosition

    method hp() = hp

    method speed() = speed

    method tickMs() = 1000/speed

    method spawn(path) {
        game.addVisual(self)
        movementTick = game.tick(self.tickMs(), {self.goForward(path)}, true)
        movementTick.start()
    }

    method despawn() {
        movementTick.stop()
    	game.removeVisual(self)
	}

    method goForward(path) {
        position = path.get(pathPosition).position()

        if (self.isAtTheEndOfThePath(path)) {
            self.doDamage(tdGame.currentStage())
        }
        
        pathPosition = path.size().min(pathPosition + 1)
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

    method receiveBasicAttack(damage){
		self.receiveDamage(damage)
	}

	method receivePiercingAttack(damage){
		self.receiveDamage(damage)
	}

	method receiveSlowingAttack(damage){
		self.receiveDamage(damage)
		self.beSlowed()
	}
    
    method receiveBlowUpDamage(damage){
        self.receiveDamage(damage)
    }

	method beSlowed(){
		game.sound("sfx_hit_slowing.wav").play()
		speed = 0.25.max(speed / 2)
        movementTick.interval(self.tickMs())
        text += "❄️"
	}

    method die() {
        hp = 0
        tdGame.discountEnemy(self)
        movementTick.stop()
        status = "dying"
        game.schedule(1000, {self.despawn()})
    }

	method isDead() = hp <= 0

}

class BasicEnemy inherits Enemy(hp = 1, power = 10, speed = 2, name = "basic"){

    override method image() {
    	return "enemy_" + name + "_" + status + "_" + hp + ".png"
    }
    
    method clone() = new BasicEnemy(hp = hp, power = power , speed = speed, name = name)
}

class ArmoredEnemy inherits Enemy(hp = 1, power = 20, speed = 2, name = "armored") {

	override method receiveBasicAttack(damage){
        self.triggerResistAttackAnimation()
		game.sound("sfx_hit_resisted.wav").play()
	}

    method triggerResistAttackAnimation() {
        status = "resisted"
        game.schedule(200, { if (status == "resisted") status = "alive"})
    }

	override method receiveSlowingAttack(damage){
		self.receiveDamage(0)
		self.beSlowed()
	}

    override method receiveBlowUpDamage(damage){
        self.triggerResistAttackAnimation()
		self.receiveDamage(0)
	}

    method clone() = new ArmoredEnemy(hp = hp , power = power, speed = speed, name = name)
}

class ExplosiveEnemy inherits Enemy(hp = 1, power = 50, speed = 2, name = "explosive") {
	const radius = 5
	
  	override method receivePiercingAttack(damage){
		self.blowUp()
	}

	override method receiveBlowUpDamage(damage){
		self.blowUp()
	}

    method blowUp() {
        self.die()
        self.enemiesInRange(tdGame.enemiesInPlay()).forEach({enemy => enemy.receiveBlowUpDamage(power)})
        game.sound("sfx_alf_pop.wav").play()
    }

    method enemiesInRange(enemies) = enemies.filter({ enemy => self.isInRange(enemy) })
  
    method isInRange(enemy) = position.distance(enemy.position()) <= radius

    method clone() = new ExplosiveEnemy(hp = hp, power = power, speed = speed, name = name)
 }

import models_game.*

class Enemy {
    var pathPosition = 0
    var property position = game.at(99, 99)
    var hp
    const power
    var speed
    var movementTick = null
    var status = "alive"

	method pathPosition() = pathPosition

    method hp() = hp

    method speed() = speed

	method status() = status

	method isDying() = status == "dying"

    method tickMs() = 1000/speed

    method spawn(path) {
        game.addVisual(self)
        movementTick = game.tick(self.tickMs(), {self.goForward(path)}, true)
        movementTick.start()
    }

    method despawn() {
    	game.removeVisual(self)
    	movementTick.stop()
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
			self.startDying()
		}
	}

	method startDying(){
		if (status != "dying") {
			status = "dying"
			if (movementTick != null) movementTick.stop()
			game.schedule(2000, { self.die() }) //le puse con delay de 2 segundos 
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
	}



    method die() {
        hp = 0
        self.despawn()
        tdGame.discountEnemy(self) 
    }

	method isDead() = hp <= 0

    method image()
}

class BasicEnemy inherits Enemy(hp = 1, power = 10, speed = 2){

    override method image() {
    	if (self.isDying()) return "enemy_basic_attacked.png"
    	return "enemy_basic_" + hp.toString() + ".png"
    }
    
    method clone() = new BasicEnemy(hp = hp, power = power , speed = speed)
}

class ArmoredEnemy inherits Enemy(hp = 1, power = 20, speed = 2) {
    override method image() {
    	if (self.isDying()) return "enemy_basic_attacked.png" // debemos crear el enemy_armored_attacked.png
    	return "enemy_armored.png"
    }

	override method receiveBasicAttack(damage){
		game.sound("sfx_hit_resisted.wav").play()
	}

	override method receiveSlowingAttack(damage){
		self.receiveDamage(0)
		self.beSlowed()
	}

    override method receiveBlowUpDamage(damage){
		self.receiveDamage(0)
	}

    method clone() = new ArmoredEnemy(hp = hp , power = power, speed = speed)
}

class ExplosiveEnemy inherits Enemy(hp = 1, power = 50, speed = 2) {
	const radius = 5

    override method image() {
    	if (self.isDying()) return "enemy_basic_attacked.png"  // debemos crear el enemy_explosive_attacked.png
    	return "enemy_explosive.png"
    }
	
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

    method clone() = new ExplosiveEnemy(hp = hp, power = power, speed = speed)
 }

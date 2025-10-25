import models_game.*

class Tower {
  var property position
  const power
  const attackSpeed
  const range
  const attack
  const cost
  const image
  var status = "idle"
  var attackTick = game.tick(1000, {   }, false)
  
  method image() = ((image + "_") + status) + ".png"
  
  method cost() = cost
  
  method power() = power
  
  method range() = range

  method attackSpeed() = attackSpeed
  
  method spawn() {
    game.addVisual(self)
    game.sound("sfx_tower_spawn.mp3").play()
    attackTick = game.tick(attackSpeed, { self.attackInRange() }, true)
    attackTick.start()
  }
  
  method despawn() {
    game.removeVisual(self)
    attackTick.stop()
  }
  
  method attackInRange() {
    self.attackEnemy(
      self.enemyToAttack(self.enemiesInRange(tdGame.enemiesInPlay()))
    )
  }
  
  method attackEnemy(enemy) {
    if (enemy != null) {
      self.triggerAttackAnimation()
      attack.doAttack(power, enemy)
    }
  }
  
  method status(newStatus) {
    status = newStatus
  }
  
  method triggerAttackAnimation() {
    self.status("attacking")
    game.schedule(250, { self.status("idle") })
  }
  
  method enemyToAttack(enemies) {
    if (enemies.isEmpty()) {
      return null
    }
    return enemies.fold(
      enemies.get(0),
      { enemyWithMaxPath, otherEnemy =>
        if (otherEnemy.pathPosition() > enemyWithMaxPath.pathPosition())
          otherEnemy
        else enemyWithMaxPath }
    )
  }
  
  method enemiesInRange(enemies) = enemies.filter(
    { enemy => self.isInRange(enemy) }
  )
  
  method isInRange(enemy) = position.distance(enemy.position()) <= range
  
  method cloneInPosition(newPosition) = new Tower(
    position = newPosition,
    power = power,
    attackSpeed = attackSpeed,
    range = range,
    attack = attack,
    cost = cost,
    image = image
  )
}

object basicAttack {
  method doAttack(damage, enemy) {
    enemy.receiveBasicAttack(damage)
  }
}

object piercingAttack {
  method doAttack(damage, enemy) {
    enemy.receivePiercingAttack(damage)
  }
}

object slowingAttack {
  method doAttack(damage, enemy) {
    enemy.receiveSlowingAttack(damage)
  }
}

const basicTower = new Tower(
  position = game.at(99,99),
  power = 1,
  attackSpeed = 1500,
  range = 4,
  attack = basicAttack,
  cost = 50,
  image = "tower_basic"
)

const piercingTower = new Tower(
  position = game.at(99,99),
  attack = piercingAttack,
  power = 1,
  cost = 150,
  range = 2,
  attackSpeed = 1500,
  image = "tower_piercing"
)

const slowingTower = new Tower(
  position = game.at(99,99),
  attack = slowingAttack,
  power = 0,
  cost = 100,
  range = 3,
  attackSpeed = 2000,
  image = "tower_slowing"
)
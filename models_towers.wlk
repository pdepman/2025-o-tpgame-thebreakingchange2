import models_game.*

class Tower {
  var property position
  const power
  const attackSpeed
  const range
  const attack
  const cost
  var attackTick = game.tick(1000, {   }, false)
  
  method image()
  
  method cost() = cost
  
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
    if (enemy != null) attack.doAttack(power, enemy)
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

class BasicTower inherits Tower {
  override method image() = "tower_basic.png"
}

class PiercingTower inherits Tower {
  override method image() = "tower_piercing.png"
}

class SlowingTower inherits Tower {
  override method image() = "tower_slowing.png"
}
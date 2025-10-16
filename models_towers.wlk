import models_game.*

class Tower {
  var property position
  var power
  var attackSpeed
  var range
  var attack
  const tickId = "towerScan_" + self.identity()
  
  method image()
  
  method spawn() {
    game.addVisual(self)
    game.sound("sfx_tower_spawn.mp3").play()
    game.onTick(500, tickId, { self.attackEnemy(self.enemyToAttack()) })
  }
  
  method attackEnemy(enemy) {
    if (enemy != null) attack.doAttack(power, enemy)
  }
  
  method enemyToAttack() {
    const enemiesFiltered = self.enemiesInRange()
    return enemiesFiltered.fold(
      enemiesFiltered.get(0),
      { enemyWithMaxPath, otherEenemy =>
        if (otherEenemy.pathPosition() > enemyWithMaxPath.pathPosition())
          otherEenemy
        else enemyWithMaxPath }
    )
  }
  
  method enemiesInRange() {
    const enemies = tdGame.currentStage().currentRound().enemies()
    return enemies.filter(
      { enemy => (position.distance(
          enemy.position()
        ) <= range) && enemy.isDead().negate() }
    )
  }
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
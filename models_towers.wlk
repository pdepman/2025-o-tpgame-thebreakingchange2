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
    game.onTick(
      1000,
      tickId,
      { self.attackEnemy(
          self.enemyToAttack(
            self.enemiesInRange(tdGame.currentStage().currentRound().enemies())
          )
        ) 
      }
    )
  }
  
  method attackEnemy(enemy) {
    if (enemy != null){ // Queremos sacar esto de aca
      attack.doAttack(power, enemy)
    }
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
  
  method isInRange(enemy) = (position.distance(
    enemy.position()
  ) <= range) && enemy.isDead().negate()
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
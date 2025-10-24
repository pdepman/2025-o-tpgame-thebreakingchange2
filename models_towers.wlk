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

  
  method image() = image + "_" + status + ".png"
  
  method cost() = cost
  
  method power() = power
  
  method range() = range
  
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

  method status(newStatus) { status = newStatus} 
  
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



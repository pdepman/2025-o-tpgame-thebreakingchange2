import models_hud.*
import stage_0.*
import models_towers.*

object tdGame {
  const stages = [stage_0]
  var currentStage = placeHolderStage
  
  method currentStage() = currentStage

  method setupConfig() {
    game.title("Tower Defense")
    game.height(14)
    game.width(23)
    game.cellSize(60)
    game.ground("tile_default.png")
  }
  
  method start() {
    self.setupConfig()
    game.start()
  }
  
  method selectStage(stageNumber) {
    currentStage = stages.get(stageNumber)
  }
  
  method loadStage() {
    currentStage.load()
  }
}
class BasicPlayer {
	var property towers = []
	var property position
	
	method image() = "player.png"
	
	method addBasicTower() {
		towers.add(
			new BasicTower(
				attack = basicAttack,
				position = position,
				power = 10,
				attackSpeed = 1000,
				range = 2
			)
		)
		towers.last().spawn()
	}

	method addPiercingTower() {
		towers.add(
			new PiercingTower(
				attack = piercingAttack,
				position = position,
				power = 10,
				attackSpeed = 1000,
				range = 2
			)
		)
		towers.last().spawn()
	}

	method addSlowingTower() {
		towers.add(
			new SlowingTower(
				attack = slowingAttack,
				position = position,
				power = 10,
				attackSpeed = 1000,
				range = 2
			)
		)
		towers.last().spawn()
	}

	method towersIsEmpty() = towers.isEmpty()
}

class Stage {
	const path
	const core
	const rounds
	var resources
	var roundIndex = 0


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

	method currentRound() = rounds.get(roundIndex)

	method startCurrentRound() {
		self.currentRound().start()
	}

	method advanceRoundIndex() {
		roundIndex += 1
	}

    method win(){
        victoryScreen.beDisplayed()
    }

    method completeRound() {
      if (self.isComplete()){
        self.win()
      } else {
        self.advanceRoundIndex()
      }
    }

    method isComplete() = rounds.all({round => round.isComplete()})
    

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

class Round {
	const enemies
	const resourcesReward
    var enemiesRemaining = enemies.size()
	var enemiesIndex = 0
	const tickId = "round-" + self.identity() + "control"

	method enemies() = enemies

	method resourcesReward() = resourcesReward

    method enemiesRemaining() = enemiesRemaining

	method start() {
		game.onTick(2000, tickId, { self.spawnNextEnemy() })
	}
	method spawnNextEnemy() {
		if (enemiesIndex < enemies.size()) {
			self.nextEnemy().spawn()
			self.advanceEnemiesIndex()
		}
	}
	method nextEnemy() = enemies.get(enemiesIndex)
	method advanceEnemiesIndex() { enemiesIndex += 1 }
	method end() {
		game.removeTickEvent(tickId)
        tdGame.currentStage().completeRound()
	}

    method discountEnemy() {
        enemiesRemaining -= 1
        if (self.isComplete()){
            self.end()
        }
    }

    method isComplete() = enemiesRemaining == 0

}

const placeHolderStage = new Stage(
  path = new Path(roads = []),
  core = new Core(position = game.start(), hp = 100),
  resources = 100,
  rounds = [placeHolderRound]
)

const placeHolderRound = new Round(enemies = [], resourcesReward = 100)

import models_hud.*
import stage_0.stage_0
import stage_1.stage_1
import models_towers.*

object tdGame {
	const stages = [stage_0, stage_1]
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

	method startCurrentRound() {
		currentStage.startCurrentRound()
	}

	method core() = currentStage.core()
}

class BasicPlayer {
	var property position
	
	method image() = "player.png"
	
	method addTower(tower, stage) {
		if (self.isInBuildingZone(stage.path())) stage.addTower(tower)
		else game.sound("sfx_cannot_build.mp3").play()
	}
	
	method isInBuildingZone(prohibitedZones) = prohibitedZones.any(
		{ road => road.position() == position }
	).negate()

	
	// method blockedMove()
}

class Stage {
	const path
	const core
	const rounds
	const towers = []
	var resources
	var roundIndex = 0
	
	method load() {
		self.displayPath()
		core.beDisplayed()
	}
	
	method clear() {
		self.removePath()
		core.beRemoved()
		towers.forEach({tower => tower.despawn()})
		// Limpio coro de la pantalla
		// Limpio el personaje de la pantalla UFF PODRIA USAR EL PERSONAJE PARA SELECCIONAR EL NIVEL
		// Vuelvo todas las variables a su estado inicial
	}
	
	method path() = path
	
	method core() = core
	
	method towers() = towers

	method reset() {
		self.clear()
		self.load()
	}
	
	method roundsRemaining() = rounds.size() - roundIndex
	
	method addResources(amount) {
		resources += amount
		game.sound("sfx_resources_added.wav").play()
	}
	
	method substractResources(amount) {
		resources -= amount
	}
	
	method resources() = resources
	
	method currentRound() = rounds.get(roundIndex)
	
	method startCurrentRound() {
		self.currentRound().start(path)
	}
	
	method advanceRoundIndex() {
		roundIndex += 1
	}
	
	method win() {
		victoryScreen.beDisplayed()
	}
	
	method lose() {
		gameOverScreen.beDisplayed()
	}
	
	method completeRound() {
		if (self.isComplete()) {
			self.win()
		} else {
			self.addResources(self.currentRound().resourcesReward())
			self.advanceRoundIndex()
		}
	}
	
	method isComplete() = rounds.all({ round => round.isComplete() })
	
	method addTower(tower) {
		if (tower.cost() <= resources) {
			self.substractResources(tower.cost())
			towers.add(tower)
			tower.spawn()
		} else {
			game.sound("sfx_cannot_build.mp3").play()
		}
	}
	
	method displayPath() {
		path.forEach({ road => road.beDisplayed() })
	}

	method removePath() {
		path.forEach({ road => road.beRemoved()})
	}

}

class Road {
	const property position
	
	method image() = "tile_road.png"
	
	method beDisplayed() {
		game.addVisual(self)
	}
	method beRemoved() {
		game.removeVisual(self)
	}
}

class Core {
	var property position
	var hp
	
	method image() = "core.png"
	
	method hp() = hp
	
	method receiveDamage(damage) {
		hp -= damage
		if(self.isDestroyed()){
			tdGame.currentStage().lose()	
		}
	}
	
	method isDestroyed() = hp <= 0
	
	method beDisplayed() {
		game.addVisual(self)
	}

	method beRemoved() {
		game.removeVisual(self)
	}
}

class Round {
	const enemies
	const resourcesReward
	var enemiesRemaining = enemies.size()
	var enemiesIndex = 0
	const tickId = ("round-" + self.identity()) + "control"
	
	method enemies() = enemies
	
	method enemiesInPlay() = enemies.subList(0, enemiesIndex).filter(
		{ enemy => !enemy.isDead() }
	)
	
	method resourcesReward() = resourcesReward
	
	method enemiesRemaining() = enemiesRemaining
	
	method start(path) {
		game.onTick(2000, tickId, { self.spawnNextEnemy(path) })
	}
	
	method spawnNextEnemy(path) {
		if (enemiesIndex < enemies.size()) {
			self.nextEnemy().spawn(path)
			self.advanceEnemiesIndex()
		}
	}
	
	method nextEnemy() = enemies.get(enemiesIndex)
	
	method advanceEnemiesIndex() {
		enemiesIndex += 1
	}
	
	method end() {
		game.removeTickEvent(tickId)
		tdGame.currentStage().completeRound()
	}
	
	method discountEnemy() {
		enemiesRemaining -= 1
		if (self.isComplete()) self.end()
	}
	
	method isComplete() = enemiesRemaining == 0
}

const placeHolderStage = new Stage(
	path = [],
	core = new Core(position = game.start(), hp = 100),
	resources = 100,
	rounds = [placeHolderRound]
)

const placeHolderRound = new Round(enemies = [], resourcesReward = 100)
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

	method discountEnemy(enemy) {
		currentStage.discountEnemy(enemy)
	}

	method enemiesRemaining() = currentStage.enemiesRemaining()

	method enemiesInPlay() = currentStage.enemiesInPlay()

	method completeRound() {
		currentStage.completeRound()
	  
	}
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
	var currentRound = rounds.dequeue()
	const towers = []
	var resources
	
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
	
	method roundsRemaining() = rounds.size() + 1
	
	method addResources(amount) {
		resources += amount
		game.sound("sfx_resources_added.wav").play()
	}
	
	method substractResources(amount) {
		resources -= amount
	}
	
	method resources() = resources
	
	method currentRound() = currentRound
	
	method startCurrentRound() {
		currentRound.start(path)
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
			self.addResources(currentRound.resourcesReward())
			currentRound = rounds.dequeue()
		}
	}
	
	method isComplete() = rounds.size() == 0
	
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

	method discountEnemy(enemy) {
		currentRound.discountEnemy(enemy)
	}

	method enemiesRemaining() = currentRound.enemiesRemaining()

	method enemiesInPlay() = currentRound.enemiesInPlay()


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
	const enemiesQueue
	const enemiesInPlay = []
	const resourcesReward
	const tickId = ("round-" + self.identity()) + "control"
	
	method enemiesQueue() = enemiesQueue
	method enemiesRemaining() = enemiesQueue.size() + enemiesInPlay.size()
	
	method enemiesInPlay() = enemiesInPlay
	
	method resourcesReward() = resourcesReward
		
	method start(path) {
		game.onTick(2000, tickId, { self.spawnNextEnemy(path) })
	}
	
	method spawnNextEnemy(path) {
		if (!enemiesQueue.isEmpty()) {
			const enemy = enemiesQueue.dequeue()
			enemy.spawn(path)
			enemiesInPlay.add(enemy)
		}
	}
	
	method end() {
		game.removeTickEvent(tickId)
		tdGame.completeRound()
	}
	
	method discountEnemy(enemy) {
		enemiesInPlay.remove(enemy)
		if (self.isComplete()) self.end()
	}

	method isComplete() = self.enemiesRemaining() == 0

}

const placeHolderStage = new Stage(
	path = [],
	core = new Core(position = game.start(), hp = 100),
	resources = 100,
	rounds = new Queue(list = [placeHolderRound])
)

const placeHolderRound = new Round(enemiesQueue = new Queue(list = []) , resourcesReward = 100)

class Queue {
	const list = []

	method enqueue(element) {
		list.add(element)
	}

	method dequeue() {
		if (list.isEmpty()) return null
		const head = list.head()
		list.remove(list.head())
		return head
	}

	method size() = list.size()

	method isEmpty() = list.isEmpty()
}
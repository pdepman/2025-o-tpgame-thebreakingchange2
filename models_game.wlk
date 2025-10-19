import models_hud.*
import stage_selector.stage_selector
import stage_0.stage_0
import stage_1.stage_1
import models_towers.*

object tdGame {
	var currentStage = stage_selector.clone()
	
	method currentStage() = currentStage
	method currentStage(stage) { currentStage = stage.clone() }
	
	method setupGame() {
		game.title("Tower Defense")
		game.height(14)
		game.width(23)
		game.cellSize(60)
		game.ground("tile_default.png")
		game.start()
	}

	method setupControls() {
		keyboard.space().onPressDo({ self.startCurrentRound() })
		keyboard.r().onPressDo({ self.swapStages(stage_selector) })
		player.controlSetup()
	}
	
	method start() {
		self.setupGame()
		self.setupControls()
		self.loadStage()
		hud.beDisplayed()
		game.addVisual(player)
	}

	method swapStages(stage) {
		currentStage.clear()
		player.position(game.at(9,4))
		self.currentStage(stage)
		currentStage.load()
		player.refreshVisualZIndex()
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

	method hp() = currentStage.hp()

	method roundsRemaining() = currentStage.roundsRemaining()

	method resources() = currentStage.resources()
}

object player {
	var property position = game.at(9,4)
	
	method image() = "player.png"
	
	method addTower(tower, stage) {
		if (self.isInBuildingZone(stage.path() + stage.towers())) stage.addTower(tower)
		else game.sound("sfx_cannot_build.mp3").play()
	}
	
	method isInBuildingZone(prohibitedZones) = prohibitedZones.any(
		{ element => element.position() == position }
	).negate()

	method controlSetup() {
		keyboard.up().onPressDo({ if(self.position().y() < game.height()-1) self.position(self.position().up(1)) })
    	keyboard.down().onPressDo({ if(self.position().y() > 0) self.position(self.position().down(1)) })
    	keyboard.right().onPressDo({ if (self.position().x() < hud.limit()) self.position(self.position().right(1))})
    	keyboard.left().onPressDo({ if (self.position().x() > 0) self.position(self.position().left(1)) })
		
		keyboard.num1().onPressDo({ self.addTower(new BasicTower(position = self.position()), tdGame.currentStage())})
		keyboard.num2().onPressDo({ self.addTower(new PiercingTower(position = self.position()), tdGame.currentStage())})
		keyboard.num3().onPressDo({ self.addTower(new SlowingTower(position = self.position()), tdGame.currentStage())})
	}

	method refreshVisualZIndex() {
		game.removeVisual(self)
		game.addVisual(self)
	}
}

class Stage {
	const path
	const rounds
	const towers = []
	var currentRound = new Round(enemiesQueue = [], resourcesReward = 0)
	var resources
	var hp = 100
	
	method path() = path
	method towers() = towers
	method resources() = resources
	method currentRound() = currentRound
	method hp() = hp

	method load() {
		self.displayPath()
		currentRound = rounds.dequeue()
	}
	
	method clear() {
		victoryScreen.removeDisplay()
		gameOverScreen.removeDisplay()
		self.removePath()
		currentRound.clear()
		towers.forEach({tower => tower.despawn()})
	}

	method clone() = new Stage(path = path, rounds = rounds.clone(), resources = resources) 

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
		path.forEach({ road => road.beDisplayed()})
	}

	method removePath() {
		path.forEach({ road => game.removeVisual(road)})
	}

	method discountEnemy(enemy) {
		currentRound.discountEnemy(enemy)
	}

	method enemiesRemaining() = currentRound.enemiesRemaining()

	method enemiesInPlay() = currentRound.enemiesInPlay()

	method receiveDamage(damage) {
		hp -= damage
		if(self.shouldLose()){
			self.lose()	
		}
	}

	method shouldLose() = hp <= 0
}

class Road {
	const property position
	
	method image() = "tile_road.png"

	method beDisplayed() = game.addVisual(self)
}

class Core {
	var property position
	
	method image() = "tile_core.png"

	method beDisplayed() {
		game.addVisual(self)
	}
}

class Round {
	const enemiesQueue
	const enemiesInPlay = []
	const resourcesReward
	const enemySpawnFrecuency = 2000
	var enemySpawnTick = game.tick(1000, { }, false)
	
	method enemiesQueue() = enemiesQueue
	method enemiesRemaining() = enemiesQueue.size() + enemiesInPlay.size()
	
	method enemiesInPlay() = enemiesInPlay
	
	method resourcesReward() = resourcesReward

	method clone() = new Round(enemiesQueue = enemiesQueue.clone(), resourcesReward = resourcesReward)
	

	method clear() {
		enemySpawnTick.stop()
		enemiesInPlay.forEach({ enemy => enemy.despawn()})
	}
		
	method start(path) {
		enemySpawnTick = game.tick(enemySpawnFrecuency, { self.spawnNextEnemy(path) }, true)
		enemySpawnTick.start()
	}
	
	method spawnNextEnemy(path) {
		if (!enemiesQueue.isEmpty()) {
			const enemy = enemiesQueue.dequeue()
			enemy.spawn(path)
			enemiesInPlay.add(enemy)
		}
	}
	
	method end() {
		enemySpawnTick.stop()
		tdGame.completeRound()
	}
	
	method discountEnemy(enemy) {
		enemiesInPlay.remove(enemy)
		if (self.isComplete()) self.end()
	}

	method isComplete() = self.enemiesRemaining() == 0

}

class Queue {
	const list = []

	method enqueue(element) {
		list.add(element)
	}

	method clone() {
		// La buena lista, nada le gana
		const clonedQueue = new Queue(list = [])
		list.forEach({element => clonedQueue.enqueue(element.clone())})
		return clonedQueue
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

class StageSelector {
	const property position
	const stage
	const name

	method image() = "tile_selector.png"
	method text() = name
	method textColor() = "FFFFFFFF"

	method beDisplayed() {
		game.addVisual(self)
		game.onCollideDo(self, {a => self.selectStage()})
	}

	method selectStage() {
		tdGame.swapStages(stage)
	}
}
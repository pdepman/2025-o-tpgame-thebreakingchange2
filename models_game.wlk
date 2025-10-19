import models_hud.*
import stage_placeholder.placeHolderStage
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

	method hp() = currentStage.hp()

	method roundsRemaining() = currentStage.roundsRemaining()

	method resources() = currentStage.resources()
}

object player {
	var property position = game.center()
	
	method image() = "player.png"
	
	method addTower(tower, stage) {
		if (self.isInBuildingZone(stage.path() + stage.towers())) stage.addTower(tower)
		else game.sound("sfx_cannot_build.mp3").play()
	}
	
	method isInBuildingZone(prohibitedZones) = prohibitedZones.any(
		{ element => element.position() == position }
	).negate()

	method beDisplayed(){
		game.addVisual(self)
		keyboard.up().onPressDo({ if(self.position().y() < game.height()-1) self.position(self.position().up(1)) })
    	keyboard.down().onPressDo({ if(self.position().y() > 0) self.position(self.position().down(1)) })
    	keyboard.right().onPressDo({ if (self.position().x() < hud.limit()) self.position(self.position().right(1))})
    	keyboard.left().onPressDo({ if (self.position().x() > 0) self.position(self.position().left(1)) })
		
		keyboard.num1().onPressDo({ self.addTower(new BasicTower(position = self.position()), tdGame.currentStage())})
		keyboard.num2().onPressDo({ self.addTower(new PiercingTower(position = self.position()), tdGame.currentStage())})
		keyboard.num3().onPressDo({ self.addTower(new SlowingTower(position = self.position()), tdGame.currentStage())})
	}
}

class Stage {
	const path
	const rounds
	const towers = []
	var currentRound = rounds.dequeue()
	var resources
	var hp = 100
	
	method path() = path
	method towers() = towers
	method resources() = resources
	method currentRound() = currentRound
	method hp() = hp

	method load() {
		self.displayPath()
	}
	
	method clear() {
		self.removePath()
		towers.forEach({tower => tower.despawn()})
	}
	
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
		path.forEach({ road => game.addVisual(road)})
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
}

class Core {
	var property position
	
	method image() = "core.png"
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

	method dequeue() {
		if (list.isEmpty()) return null
		const head = list.head()
		list.remove(list.head())
		return head
	}

	method size() = list.size()

	method isEmpty() = list.isEmpty()
}
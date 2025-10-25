import models_hud.*
import stage_selector.stage_selector
import stage_0.stage_0
import stage_1.stage_1
import models_towers.*

const optimized_mode = true

object tdGame {
	var currentStage = stage_selector.clone()
	
	method currentStage() = currentStage
	method currentStage(stage) { currentStage = stage.clone() }
	
	method setupGame() {
		game.title("Tower Defense")
		game.height(14)
		game.width(23)
		game.cellSize(60)
		game.start()
		if (optimized_mode) game.boardGround("optimized_background.png")
		else game.ground("tile_default.png")
	}

	method setupControls() {
		keyboard.e().onPressDo({ self.startCurrentRound() })
		keyboard.r().onPressDo({ self.swapStages(stage_selector) })
		keyboard.t().onPressDo({ self.swapStages(stage_0) })
		keyboard.y().onPressDo({ self.swapStages(stage_1) })
		player.controlSetup()
	}
	
	method start() {
		self.setupGame()
		self.setupControls()
		self.loadStage()
		if (optimized_mode) game.addVisual(pathDisplayer)
		hud.beDisplayed()
		game.addVisual(player)
	}

	method swapStages(stage) {
		currentStage.clear()
		player.exitTowerSelectionMode()
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

	method addTower(tower) { currentStage.addTower(tower)}

	method prohibitedZones() = currentStage.prohibitedZones()
}

class RangePrevisualizer{
	var property position
	var property range
	var tiles = []

	method tiles() = tiles

	method beDisplayed() {
	  tiles.forEach({tile => tile.beDisplayed()})
	}

	method beRemoved() {
		game.removeVisual(self)
		tiles.forEach({tile => tile.beRemoved()})
	}

	method flash(){
		self.beDisplayed()
		game.schedule(500, {self.beRemoved()})
	}

	method tilesSquare() {
		const tilesSquare = []
		(position.x()-range .. position.x()+range).forEach({tileX => (position.y()-range .. position.y()+range).forEach({tileY => tilesSquare.add(new PrevisualizerTile(position = new MutablePosition(x= tileX, y=tileY), offsetX = tileX - position.x(), offsetY = tileY - position.y()))})})
		return tilesSquare
	}

	method tilesArea() = self.tilesSquare().filter({tile => position.distance(tile.position()) <= range })

	method setPreviewTiles() {
		tiles = self.tilesArea()
	}

	method refreshPosition(newPosition) {
		position = newPosition
		tiles.forEach({tile => tile.refresh(position)})
	}

	method refreshPreview(displayAfterRefresh) {
		range = player.towerToPlace().range()
		self.beRemoved()
		self.setPreviewTiles()
		if (displayAfterRefresh) {
			self.beDisplayed()
		}
		
	}

	method clone() = new RangePrevisualizer(position = position, range = range, tiles = tiles.map({tile => tile.clone()}))

	method cloneWithTiles() {
		self.setPreviewTiles()
		return new RangePrevisualizer(position = position, range = range, tiles = tiles.map({tile => tile.clone()}))
	}

}

class PrevisualizerTile {
	var property position
	const offsetX
	const offsetY

	method image() = "tile_rangePreview.png"

	method beDisplayed() {
	  game.addVisual(self)
	}

	method beRemoved() {
		game.removeVisual(self)
	}

	method refresh(newCenterPosition) {
		position.x(newCenterPosition.x() + offsetX)
		position.y(newCenterPosition.y() + offsetY)
	}

	method clone() = new PrevisualizerTile(position = position, offsetX = offsetX, offsetY = offsetY)

}

object player {
	var property position = game.at(9,4)
	var isPlacingTower = false
	var towerToPlace = basicTower
	var image = "player.png"
	const rangePrevisualizer = new RangePrevisualizer(position = position, range = towerToPlace.range())
	
	method image() = image
	method towerToPlace() = towerToPlace
	method towerToPlace(tower) { towerToPlace = tower }

	method toggleTowerSelectionMode(){
		if (isPlacingTower) self.exitTowerSelectionMode()
		else self.enterTowerSelectionMode()
	}

	method enterTowerSelectionMode() {
		image = towerToPlace.image()
		rangePrevisualizer.beDisplayed()
		isPlacingTower = true
	}

	method exitTowerSelectionMode() {
		image = "player.png"
		rangePrevisualizer.beRemoved()
		isPlacingTower = false

	}

	method addTower(tower) {
		if (isPlacingTower){
			if (self.isInBuildingZone()) {
				tdGame.addTower(towerToPlace.cloneInPosition(position))
				self.exitTowerSelectionMode()
			}
			else {
				game.sound("sfx_cannot_build.mp3").play()
			}
		}
	}
	
	method isInBuildingZone() = tdGame.prohibitedZones().any(
		{ element => element.position() == position }
	).negate()

	method controlSetup() {
		//Movement
		keyboard.w().onPressDo({ self.moveUp() })
    	keyboard.a().onPressDo({ self.moveLeft() })
    	keyboard.s().onPressDo({ self.moveDown() })
		keyboard.d().onPressDo({ self.moveRight() })
		//Tower Selection
		keyboard.q().onPressDo({ self.toggleTowerSelectionMode()})
		keyboard.num1().onPressDo({ self.selectTower(basicTower)})
		keyboard.num2().onPressDo({ self.selectTower(piercingTower)})
		keyboard.num3().onPressDo({ self.selectTower(slowingTower)})
		keyboard.space().onPressDo({ self.addTower(towerToPlace)})
	}

	method selectTower(tower) {
		self.towerToPlace(tower)
		rangePrevisualizer.refreshPreview(isPlacingTower)
		if (isPlacingTower) {
		image = towerToPlace.image()
		}
	}

	method moveUp() {
		if(position.y() < game.height()-1) self.position(position.up(1))
		rangePrevisualizer.refreshPosition(position)
	}

	method moveDown() {
		if(position.y() > 0) self.position(position.down(1))
		rangePrevisualizer.refreshPosition(position)
	}

	method moveLeft() {
		if (position.x() > 0) self.position(position.left(1))
		rangePrevisualizer.refreshPosition(position)
	}

	method moveRight(){
		if (position.x() < hud.limit()) self.position(position.right(1))
		rangePrevisualizer.refreshPosition(position)
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
	const optimized_path_image = null
	
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

	method clone() = new Stage(path = path, rounds = rounds.clone(), resources = resources, optimized_path_image = optimized_path_image) 
	
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
		if (optimized_mode) pathDisplayer.pathImage(optimized_path_image)
		else path.forEach({ road => road.beDisplayed()})
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

	method prohibitedZones() = path + towers
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
	const enemySpawnFrequency = 2000
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
		enemySpawnTick = game.tick(enemySpawnFrequency, { self.spawnNextEnemy(path) }, true)
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

class StageSelectorTile {
	const property position
	const name

	method image() = "tile_selector.png"
	method text() = name
	method textColor() = "FFFFFFFF"

	method beDisplayed() {
		game.addVisual(self)
	}
}

object pathDisplayer {
	const property position = game.at(0,0)
	var pathImage = "optimized_stage_selector.png"

	method pathImage(newImage){ pathImage = newImage }
	method image() = pathImage
}
import classes.*
import stage_0.*

object tdGame {
    const stages = [stage_0]
    method setupConfig(){
        game.title("Tower Defense")
	    game.height(14)
	    game.width(23)
	    game.cellSize(60)
	    game.ground("tile_default.png")
    }
    method start(){
        self.setupConfig()
        game.start()
    }
    method loadStage(stageNumber){
        stages.get(stageNumber).load()
    }

}

object hud {
	const hudTiles = []

    method setupHudTiles() {
        [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13].forEach(
		{ y => [18, 19, 20, 21, 22].forEach(
				{ x => hudTiles.add(new HudTile(position = game.at(x, y))) }
			) }
	)
    }
    method beDisplayed() {
        hudTiles.forEach({ tile => game.addVisual(tile) })
    }
}

object gameOverScreen {
    const property position = game.origin()
    var beingDisplayed = false
    method image() = "gameover.png"
    method beDisplayed() {
        game.onTick(500, "gameOverDisplayControl", {self.toggleVisual()})
    }
    method removeDisplay(){
        game.removeTickEvent("gameOverDisplayControl")
        game.removeVisual(self)
    }
    method toggleVisual(){
        if (beingDisplayed) {
            game.removeVisual(self)
            beingDisplayed = false
        } else {
            game.addVisual(self)
            beingDisplayed = true
        }
    }
}
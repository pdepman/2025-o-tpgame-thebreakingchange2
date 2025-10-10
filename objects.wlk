import classes.*
import stage_0.*

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

object hud {
  const hudTiles = []
  
  //const roundVisualizer
  //const hpVisualizer
  method setupHudTiles() {
    hudTiles.add(
      new HudTile(position = game.at(18, 0), hudPosition = "bottom_left")
    )
    hudTiles.add(
      new HudTile(position = game.at(18, 13), hudPosition = "top_left")
    )
    hudTiles.add(
      new HudTile(position = game.at(22, 0), hudPosition = "bottom_right")
    )
    hudTiles.add(
      new HudTile(position = game.at(22, 13), hudPosition = "top_right")
    )
    
    [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12].forEach(
      { y => hudTiles.add(
          new HudTile(position = game.at(18, y), hudPosition = "left")
        ) }
    )
    
    [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12].forEach(
      { y => hudTiles.add(
          new HudTile(position = game.at(22, y), hudPosition = "right")
        ) }
    )
    
    [19, 20, 21].forEach(
      { x => hudTiles.add(
          new HudTile(position = game.at(x, 0), hudPosition = "bottom")
        ) }
    )
    [19, 20, 21].forEach(
      { x => hudTiles.add(
          new HudTile(position = game.at(x, 13), hudPosition = "top")
        ) }
    )
    
    [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12].forEach(
      { y => [19, 20, 21].forEach(
          { x => hudTiles.add(
              new HudTile(position = game.at(x, y), hudPosition = "center")
            ) }
        ) }
    )
  }
  
  method beDisplayed() {
    hudTiles.forEach({ tile => game.addVisual(tile) })
    resourcesVisualizer.beDisplayed()
  }
}

object resourcesVisualizer {
  var property position = game.at(20, 10)
  
  method text() = tdGame.currentStage().resources().toString()
  
  method textColor() = "FFFFFFFF"
  
  method beDisplayed() {
    game.addVisual(hudCoinSymbol)
    game.addVisual(self)
  }
}

object hudCoinSymbol {
  var property position = game.at(19, 10)
  
  method image() = "resource_coin.png"
}

object gameOverScreen {
  const property position = game.origin()
  var beingDisplayed = false
  
  method image() = "screen_gameover.png"
  
  method beDisplayed() {
    game.onTick(500, "gameOverDisplayControl", { self.toggleVisual() })
  }
  
  method removeDisplay() {
    game.removeTickEvent("gameOverDisplayControl")
    game.removeVisual(self)
  }
  
  method toggleVisual() {
    if (beingDisplayed) {
      game.removeVisual(self)
      beingDisplayed = false
    } else {
      game.addVisual(self)
      beingDisplayed = true
    }
  }
}

const placeHolderStage = new Stage(
  path = new Path(roads = []),
  core = new Core(position = game.start(), hp = 100),
  resources = 100
)
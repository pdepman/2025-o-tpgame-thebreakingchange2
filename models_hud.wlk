import models_game.*

class HudTile {
	var property position
	const hudPosition
	
	method image() = "hud_bg_"+ hudPosition +".png"
}


object hud {
  const hudTiles = []

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
    gameTitle.beDisplayed()
    stageProgressVisualizer.beDisplayed()
    enemiesRemainingVisualizer.beDisplayed()
    resourcesVisualizer.beDisplayed()
    hpVisualizer.beDisplayed()
  }
}

object gameTitle {
  const property position = game.at(19, 12)
  method image() = "hud_game_title.png"

  method beDisplayed(){
    game.addVisual(self)
  }
}


object stageProgressVisualizer {
  const property position = game.at(19, 10)

  method text() = "🚩 " + tdGame.currentStage().roundsRemaining().toString()
  method textColor() = "FFFFFFFF"

  method beDisplayed(){
    game.addVisual(self)
  }
}

object enemiesRemainingVisualizer {
  const property position = game.at(21, 10)

  method text() = "💀 " + tdGame.currentStage().currentRound().enemiesRemaining().toString()
  method textColor() = "FFFFFFFF"

  method beDisplayed(){
    game.addVisual(self)
  }
}

object hpVisualizer {
  const property position = game.at(19, 9)

  method text() = "❤️ " + tdGame.currentStage().core().hp().toString()

  method textColor() = "FFFFFFFF"

  method beDisplayed(){
    game.addVisual(self)
  }
}

object resourcesVisualizer {
  const property position = game.at(21, 9)
  
  method text() = "🪙 " + tdGame.currentStage().resources().toString()
  
  method textColor() = "FFFFFFFF"
  
  method beDisplayed() {
    game.addVisual(self)
  }
}

class ImageDisplayable {
  const property position
  const imagePath

  method image() = imagePath

  method beDisplayed() {
    game.addVisual(self)
  }

}


class FancyScreen {
    
  const property position = game.origin()
  var beingDisplayed = false
  
  method image()
  
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

object gameOverScreen inherits FancyScreen{
    override method image() = "screen_gameover.png"
}

object victoryScreen inherits FancyScreen{
    override method image() = "screen_victory.png"
}

import classes.*

const stage_0 = new Stage(path = stage_0_path, core = stage_0_core)

// Path Configuration
const stage_0_path = new Path(roads = [
  new Road(position = game.at(2, 2)),
  new Road(position = game.at(2, 3)),
  new Road(position = game.at(2, 4)),
  new Road(position = game.at(2, 5)),
  new Road(position = game.at(2, 6)),
  new Road(position = game.at(3, 6)),
  new Road(position = game.at(4, 6)),
  new Road(position = game.at(5, 6)),
  new Road(position = game.at(6, 6)),
  new Road(position = game.at(6, 5)),
  new Road(position = game.at(6, 4)),
  new Road(position = game.at(5, 4)),
  new Road(position = game.at(4, 4)),
  new Road(position = game.at(4, 5)),
  new Road(position = game.at(4, 6)),
  new Road(position = game.at(4, 7)),
  new Road(position = game.at(4, 8))
]) 

const stage_0_core = new Core(position = game.at(4, 8), hp = 100)
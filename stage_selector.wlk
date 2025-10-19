import models_game.*

const stage_selector = new Stage(
	path = path,
	resources = 0,
	rounds = new Queue(list = [placeHolderRound])
)

const placeHolderRound = new Round(enemiesQueue = new Queue(list = []) , resourcesReward = 100)


const path = [
// W
new Road(position = game.at(1, 11)),
new Road(position = game.at(1, 10)),
new Road(position = game.at(1, 9)),
new Road(position = game.at(1, 8)),
new Road(position = game.at(2, 7)),
new Road(position = game.at(3, 8)),
new Road(position = game.at(3, 9)),
new Road(position = game.at(4, 7)),
new Road(position = game.at(5, 8)),
new Road(position = game.at(5, 9)),
new Road(position = game.at(5, 10)),
new Road(position = game.at(5, 11)),
//T
new Road(position = game.at(7, 11)),
new Road(position = game.at(8, 11)),
new Road(position = game.at(9, 11)),
new Road(position = game.at(10, 11)),
new Road(position = game.at(11, 11)),
new Road(position = game.at(9, 10)),
new Road(position = game.at(9, 9)),
new Road(position = game.at(9, 8)),
new Road(position = game.at(9, 7)),
//D
new Road(position = game.at(13, 11)),
new Road(position = game.at(14, 11)),
new Road(position = game.at(15, 11)),
new Road(position = game.at(13, 10)),
new Road(position = game.at(13, 9)),
new Road(position = game.at(13, 8)),
new Road(position = game.at(13, 7)),
new Road(position = game.at(14, 7)),
new Road(position = game.at(15, 7)),
new Road(position = game.at(16, 8)),
new Road(position = game.at(16, 9)),
new Road(position = game.at(16, 10))
]


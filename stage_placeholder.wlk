import models_game.*

const placeHolderStage = new Stage(
	path = [],
	core = new Core(position = game.start(), hp = 100),
	resources = 100,
	rounds = new Queue(list = [placeHolderRound])
)

const placeHolderRound = new Round(enemiesQueue = new Queue(list = []) , resourcesReward = 100)
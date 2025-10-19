import models_game.*

const placeHolderStage = new Stage(
	path = [],
	resources = 100,
	rounds = new Queue(list = [placeHolderRound])
)

const placeHolderRound = new Round(enemiesQueue = new Queue(list = []) , resourcesReward = 100)
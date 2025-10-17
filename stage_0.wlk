import models_game.*
import models_enemies.*

const stage_0 = new Stage(path = path, core = core, resources = 100, rounds = [round_0, round_1, round_2, round_3] )

// Path Configuration
const path = [
new Road(position = game.at(2, 7)),
new Road(position = game.at(3, 7)),
new Road(position = game.at(4, 7)),
new Road(position = game.at(5, 7)),
new Road(position = game.at(6, 7)),
new Road(position = game.at(7, 7)),
new Road(position = game.at(8, 7)),
new Road(position = game.at(9, 7)),
new Road(position = game.at(10, 7)),
new Road(position = game.at(11, 7)),
new Road(position = game.at(12, 7)),
new Road(position = game.at(13, 7)),
new Road(position = game.at(14, 7)),
new Road(position = game.at(15, 7))
]

const core = new Core(position = game.at(15,7), hp = 100)

const round_0 = new Round(enemies = [
    new BasicEnemy(hp = 1 , power = 10, speed = 2),
    new BasicEnemy(hp = 1 , power = 10, speed = 2),
    new BasicEnemy(hp = 1 , power = 10, speed = 2),
    new BasicEnemy(hp = 1 , power = 10, speed = 2),
    new BasicEnemy(hp = 1 , power = 10, speed = 2)
], resourcesReward = 100)

const round_1 = new Round(enemies = [
    new BasicEnemy(hp = 1 , power = 10, speed = 2),
    new BasicEnemy(hp = 1 , power = 10, speed = 2),
    new ArmoredEnemy(hp = 1, power = 10, speed = 1)
], resourcesReward = 200)

const round_2 = new Round(enemies = [
    new BasicEnemy(hp = 1 , power = 10, speed = 2),
    new ArmoredEnemy(hp = 1, power = 10, speed = 2),
    new BasicEnemy(hp = 1 , power = 10, speed = 2),
    new ArmoredEnemy(hp = 1, power = 10, speed = 2),
    new BasicEnemy(hp = 1 , power = 10, speed = 2),
    new ArmoredEnemy(hp = 1, power = 10, speed = 2),
    new BasicEnemy(hp = 1 , power = 10, speed = 2),
    new ArmoredEnemy(hp = 1, power = 10, speed = 2)
], resourcesReward = 200)

const round_3 = new Round(enemies = [
    new BasicEnemy(hp = 1 , power = 10, speed = 2),
    new ArmoredEnemy(hp = 1, power = 10, speed = 2),
    new ExplosiveEnemy(hp = 1 , power = 10, speed = 2),
    new BasicEnemy(hp = 1 , power = 10, speed = 2),
    new ExplosiveEnemy(hp = 1 , power = 10, speed = 2),
    new ArmoredEnemy(hp = 1, power = 10, speed = 2),
    new ExplosiveEnemy(hp = 1 , power = 10, speed = 2),
    new ExplosiveEnemy(hp = 1 , power = 10, speed = 2),
    new ExplosiveEnemy(hp = 1 , power = 10, speed = 2)
], resourcesReward = 200)
extends Node

enum Gun {
	SINGLE,
	SHOTGUN,
	ROCKET
}

enum Level {SUBWAY, SKY, SEWER}
const LEVEL_PATHS = {
	Level.SUBWAY : "res://scenes/levels/subway.tscn",
	Level.SKY : "res://scenes/levels/sky.tscn",
	Level.SEWER : "res://scenes/levels/sewer.tscn",
}

enum Enemy {DRONE, SOLDIER}

var current_level : Level = Level.SUBWAY
var player_health : float = 5
var enemy_data : Dictionary

extends Node

signal player_died
signal health_changed(value)

const MAX_PLAYER_HEALTH: int = 100

var player_health: int = MAX_PLAYER_HEALTH
var current_wave := 1
var is_wave_running = false

var current_score := 0

func reset_player():
	player_health = MAX_PLAYER_HEALTH

func damage_player(atk: int):
	if (player_health <= 0):
		return
	player_health = max(0, player_health - atk)
	emit_signal("health_changed", player_health)
	if (player_health <= 0):
		emit_signal("player_died")
		
func increment_score(increment: int):
	if increment <= 0:
		return
	current_score += increment
	print(current_score)

extends Node

var player
	
func _on_player_death():
	print("death")
	pass


func _on_Timer_timeout():
	player = get_parent().get_node("Player")
	player.connect("death", self, "_on_player_death")

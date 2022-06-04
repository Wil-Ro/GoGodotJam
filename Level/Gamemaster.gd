extends Node

var player
var endZone

func _ready():
	yield(get_tree(), "idle_frame")
	endZone = get_tree().get_nodes_in_group("endPoint")[0]
	endZone.connect("level_end", self, "on_level_end")


func _on_player_death():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)	
	get_tree().change_scene("res://Huds/Menu.tscn")
	pass


func _on_Timer_timeout():
	player = get_parent().get_node("Player")
	player.connect("death", self, "_on_player_death")
	
func on_level_end():
	yield(Fade.fade_out(1), "finished")
	endZone.disconnect("level_end", self, "on_level_end")
	get_parent().eraseArena()
	get_parent().generateArena()
	Fade.fade_in(1)
	endZone = get_tree().get_nodes_in_group("endPoint")[0]
	endZone.connect("level_end", self, "on_level_end")


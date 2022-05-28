# this should generate the levels and enemies
extends Spatial

export(Array, PackedScene) var sections
export(PackedScene) var Player


func _ready():
	randomize()
	generateArena()
	var player = Player.instance()
	add_child(player)
	player.translation = Vector3(0, 3, 0)

func generateArena():
	var currentAddLocation = Vector3.ZERO
	for i in range((randi() % 4) + 1):
		print ("making 1")
		# create and store a random section
		var currentSection = sections[randi() % sections.size()].instance()
		add_child(currentSection)
		
		# we have a position called connector and one called reciever, we want the con and rec to connect the sections
		currentSection.translation = currentAddLocation
		currentAddLocation = currentSection.get_node("Connector").translation


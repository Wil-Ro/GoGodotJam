# this should generate the levels and enemies
extends Spatial

export(Array, PackedScene) var sections
export(PackedScene) var Player


func _ready():
	# set-up
	randomize()
	
	# calculate enemies
	
	
	# build level
	generateArena()
	
	# add player
	var player = Player.instance()
	add_child(player)
	player.translation = Vector3(0, 1, 0)

func generateArena():
	var currentAddLocation = Transform()
	var valCache = [-1, -1] # we put -1 in here so that randomVal is in the cache to start. We use -1 because it wont mess with anything
	var randomVal = -1
	for i in range(5): #(randi() % 4) + 1
		# generate a nice random number
		while randomVal in valCache:
			randomVal = randi() % sections.size()
		valCache.push_front(randomVal)
		valCache.pop_back()
		
		#create and store section
		var currentSection = sections[randomVal].instance()
		add_child(currentSection)
		
		# move section
		currentSection.transform = currentAddLocation
		if i != 0:
			currentSection.transform = currentSection.transform.translated(Vector3.ZERO - currentSection.get_node("Reciever").translation)
		currentAddLocation = currentSection.get_node("Connector").global_transform
		
		# add enemies to section


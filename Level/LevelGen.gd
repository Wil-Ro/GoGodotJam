# this should generate the levels and enemies
extends Spatial

export(Array, PackedScene) var sections
export(PackedScene) var startRoom
export(PackedScene) var endRoom
export(PackedScene) var Player
export(PackedScene) var enemy

var averageEnemyStats = [1, 1, 10, 10, 2, 0]

func _ready():
	# set-up
	randomize()

	# build level with player
	generateArena()

func generateArena():
	# if our array stating the surviving enemies from the last round has data in, make enemies differently
	var currentAddLocation = Transform()
	var valCache = [-1, -1] # we put -1 in here so that randomVal is in the cache to start. We use -1 because it wont mess with anything
	var randomVal = -1
	var levelSize = 4 #(randi() % sections.size()) + 1
	var currentSection
	for i in range(levelSize):
		#create and store section
		match i+1:
			1:
				currentSection = startRoom.instance()
			levelSize:
				currentSection = endRoom.instance()
			_:
				while randomVal in valCache:
					randomVal = randi() % sections.size()
				valCache.push_front(randomVal)
				currentSection = sections[randomVal].instance()
		add_child(currentSection)
		
		# move section
		currentSection.transform = currentAddLocation
		if i != 0:
			currentSection.transform = currentSection.transform.translated(Vector3.ZERO - currentSection.get_node("Reciever").translation)
		currentAddLocation = currentSection.get_node("Connector").global_transform
		currentSection.add_to_group("levelEntities")
		
		# add enemies to section
		for j in currentSection.get_node("Navigation").get_children():
			if "EnemySpawns" in j.get_groups():
				var currentEnemy = enemy.instance()
				currentEnemy.add_to_group("Enemies")
				currentEnemy.add_to_group("levelEntities")
				currentSection.get_node("Navigation").add_child(currentEnemy)
				currentEnemy.transform = j.transform
				#set up values
				currentEnemy.base_speed = averageEnemyStats[0]
				currentEnemy.damage = averageEnemyStats[1]
				currentEnemy.health = averageEnemyStats[2]
				currentEnemy.sight_chance = averageEnemyStats[3]
				currentEnemy.sight_radius = averageEnemyStats[4]
				currentEnemy.aggro = averageEnemyStats[5]
	var player = Player.instance()
	add_child(player)
	player.translation = Vector3(0, 1, 0)
	player.add_to_group("levelEntities")


func eraseArena():
	var valueCache = []# this will be fucking massive
	var finalValues = []
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		valueCache.append([enemy.base_speed, enemy.damage, enemy.health, enemy.sight_chance, enemy.sight_radius, enemy.aggro])
	for i in range(valueCache[0].size()): # x axis
		var singleVarCache = 0
		for j in range(valueCache.size()):# y axis
			singleVarCache += valueCache[j][i]
		
		var finalSingleVal = (singleVarCache/valueCache.size())
		if randi()%2 == 1:
			finalSingleVal += 1
		finalSingleVal = clamp(finalSingleVal, 0, 10)
		finalValues.append(finalSingleVal)
	averageEnemyStats = finalValues
	print(averageEnemyStats)
		
	for child in get_children():
		if "levelEntities" in child.get_groups():
			child.queue_free()
	pass

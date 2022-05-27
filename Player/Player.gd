extends KinematicBody

#exported variables get sent out to the editor
export var speed = 1
export var fall_acceleration = 75

var velocity = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta): #called per frame for physics stuff
	#this will create an empty vector, add any movement to it, then apply it to the player
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("PlayerForward"):
		direction.y += 1
	if Input.is_action_pressed("PlayerBack"):
		direction.y -= 1
	if Input.is_action_pressed("PlayerLeft"):
		direction.x += 1
	if Input.is_action_pressed("PlayerRight"):
		direction.x -= 1

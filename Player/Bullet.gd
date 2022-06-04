extends KinematicBody

var endpoint = Vector3.ZERO
var startpoint = Vector3.ZERO
var speed = 30

func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if global_transform.origin.distance_to(endpoint) < 0.5:
		queue_free()
		pass
	
	var direction = (endpoint - global_transform.origin).normalized()
	move_and_slide(direction * speed, Vector3.UP)
	


func _on_Timer_timeout():
	queue_free()

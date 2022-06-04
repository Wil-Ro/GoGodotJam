extends KinematicBody

# ---changing values---
# all of these should be between 1 and 10
# base - these should total to 30(?)
export var base_speed = 1 # normal walking speed
export var damage = 1 # damage dealt
export var health = 10 # health
export var sight_chance = 10 # how likely it is to notice the player
export var sight_radius = 2 # length of sight
export var aggro = 0 # likelyness to run away when injured

# extra abilities
export var dash_speed = 0 # speed when doing sudden dash to player, 0 to not dash

# ---code---
# global vars
enum mode {idle, attack, run}
var currentMode = mode.idle

var walkPath = []
var currentWalkPathNode = 0

var target
var animator
var navigator



func _ready():
	# add self to group
	
	$ViewSphere.get_node("ViewSphereCollider").shape.set_radius(sight_radius)
	# instance a mesh depending on stats
	animator = $Mesh.get_node("AnimationPlayer")
	navigator = get_parent()
	

func _process(delta):
	match currentMode:
		mode.idle:
			pass
		mode.attack:
			if global_transform.origin.distance_to(target.global_transform.origin) < 1.2:
				attack()
		mode.run:
			pass
	
func _physics_process(delta):
	# somethings not using global here
	# if we're not attacking and theres somewhere to go
	if animator.current_animation != "lunge":
		if currentWalkPathNode < walkPath.size(): 
			var direction = (walkPath[currentWalkPathNode] - global_transform.origin)
			if direction.length() < 1:
				currentWalkPathNode += 1
			else:
				animator.play("run-loop", -1, base_speed)
				look_at(walkPath[currentWalkPathNode], Vector3.UP)
				move_and_slide(direction.normalized() * base_speed, Vector3.UP )
		else:
			animator.play("idle-loop")
	
	# gravity
	var fall = Vector3.ZERO
	fall.y -= 75 * delta
	move_and_slide(fall, Vector3.UP)
	


func _on_ViewSphere_body_entered(body):
	if currentMode == mode.idle and body.name == "Player" and randi()%10 <= sight_chance:
		currentMode = mode.attack
		target = body
# on hit signal should go here


func _target_timer_end():
	if currentMode == mode.attack:
		set_target(target.global_transform.origin) #this probs wont work

func set_target(target_pos): #sets what we chase, THIS RELIES ON OUR PARENT BEING A NAVMESH!
	walkPath = navigator.get_simple_path(global_transform.origin, target_pos, true)
	currentWalkPathNode = 0

func attack():
	if animator.current_animation != "lunge":
		animator.play("lunge")
		if $RayCast.is_colliding() and $RayCast.get_collider().name == "Player":
			target.take_damage(damage)
			animator.queue("idle-loop")
		else:
			look_at(target.global_transform.origin, Vector3.UP)

func damage(dmg):
	health -= dmg
	if health <= 0:
		#blood particles
		queue_free()

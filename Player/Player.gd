extends KinematicBody

# external
export var speed = 5
signal death
# properties of player
var health = 10
var fall_acceleration = 30
var velocity = Vector3.ZERO
var spread = 3
# settings
var mouse_sens = 0.3
var camera_anglev = 0
# nodes
var RayCastContainer
var Bullet = load("res://Player/Bullet.tscn")
var GunTimer



# --- boiler plate ---
func _ready():
	# on start, hide mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)	
	RayCastContainer = $Camera/RayCastContainer
	GunTimer = $GunTimer
func _notification(notif):
	# on quit, free mouse
	if notif == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x*mouse_sens))
		var changev = event.relative.y*mouse_sens
		#clamp y rotation
		if camera_anglev + changev > -90 and camera_anglev + changev < 90:
			camera_anglev += changev
			$Camera.rotate_x(deg2rad(changev))
	if event is InputEventKey and event.scancode == KEY_ESCAPE:
		get_tree().quit()
	
func _process(delta):
	var currentBullet
	if Input.is_action_pressed("PlayerShoot") and get_tree().get_nodes_in_group("Bullets").size() <= 0 and GunTimer.time_left <= 0:
		for ray in RayCastContainer.get_children():
			ray.rotation_degrees += Vector3(rand_range(-spread, spread), rand_range(-spread, spread), rand_range(-spread, spread))
			if ray.is_colliding() and "Enemies" in ray.get_collider().get_groups():
				ray.get_collider().damage(1)
			currentBullet = Bullet.instance()
			ray.add_child(currentBullet)
			currentBullet.add_to_group("Bullets")
			currentBullet.endpoint = ray.to_global(ray.cast_to)
			currentBullet.startpoint = currentBullet.global_transform.origin
			
			# reset everything
			ray.rotation = Vector3.ZERO
		GunTimer.start()
				

func _physics_process(delta):
	# create empty vector, alter it, add to movement
	var direction = Vector3.ZERO
	
	
	if Input.is_action_pressed("PlayerForward"):
		direction.z += 1
	if Input.is_action_pressed("PlayerBack"):
		direction.z -= 1
	if Input.is_action_pressed("PlayerLeft"):
		direction.x += 1
	if Input.is_action_pressed("PlayerRight"):
		direction.x -= 1

	if Input.is_action_pressed("PlayerJump") and is_on_floor():
		velocity.y += 10
	
	# clean up vectors by normalizing
	# rotate the movement direction by our objects actual rotation so we move where we look
	direction = direction.rotated(Vector3.UP, rotation.y)
	if direction != Vector3.ZERO:
		direction = direction.normalized()
	
	# add direction to velocity then move and store new velocity
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	velocity.y -= fall_acceleration * delta
	velocity = move_and_slide(velocity, Vector3.UP) # this returns a changed velocity but not sure how?

func take_damage(dmg):
	health -= dmg
	if health <= 0:
		emit_signal("death")

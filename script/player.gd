extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 20
const ACCELERATION = 50
const MAX_SPEED = 200
const JUMP_HEIGHT = -500
const STATE_IDLE = 0
const STATE_PUSH = 5
#All const vars must be capitalized and usually equate to a number
onready var animated_sprite = $Sprite

export(float) var push_strength  = 50

var state = STATE_IDLE
var previous_pushed_object = null
var spritedir = "left"
var motion = Vector2(0,0) #Vectors contain x and y into a single variable
var keys = 0

func _physics_process(delta):
	spritedir_loop()
	motion.y += GRAVITY
	var friction = false
	var pushed_object = null
	var push_vector
	var previous_state = state
	if Input.is_action_pressed("ui_right"):
		motion.x = min(motion.x + ACCELERATION, MAX_SPEED)
		animated_sprite.flip_h = false
		animated_sprite.play("move")
		pushed_object = get_pushed_object($RightRay)
		push_vector = Vector2(push_strength, -20)
	elif Input.is_action_pressed("ui_left"):
		motion.x = max(motion.x - ACCELERATION, -MAX_SPEED)
		animated_sprite.flip_h = true #flips sprite horizontally
		animated_sprite.play("move")
		pushed_object = get_pushed_object($LeftRay)
		push_vector = Vector2(-push_strength, -20)
	elif Input.is_action_pressed("ui_accept"):
		animated_sprite.play("action")
	else:
		if is_on_floor():
			animated_sprite.play("idle")
			friction = true
			var collision = move_and_collide(Vector2(0, 10))
			if collision != null:
				var angle = Vector2(0, -1).angle_to(collision.normal)
				motion = motion.rotated(angle)
				if push_vector != null:
					push_vector = push_vector.rotated(angle)
			if pushed_object != null:
				pushed_object.push(push_vector, delta)
			state = STATE_PUSH
			if Input.is_action_just_pressed("ui_up"):
				motion.y = JUMP_HEIGHT
			if friction == true:
				motion.x = lerp(motion.x, 0, 0.2)
			else:
				if motion.y < 0:
					animated_sprite.play("jump")
					pushed_object = null
				else:
					animated_sprite.play("fall")
				if friction == true:
					motion.x = lerp(motion.x, 0, 0.05)
					pushed_object = null

	if is_on_wall():
		if "left" and test_move(transform, Vector2(-1, 0)):
			animated_sprite.play("push-pull")
		if "right" and test_move(transform, Vector2(1, 0)):
			animated_sprite.play("push-pull")
	motion = move_and_slide(motion, UP)
	if previous_pushed_object != pushed_object:
		if previous_pushed_object != null:
			previous_pushed_object.push(Vector2(0, 0), 0)
		previous_pushed_object = pushed_object
		print("Pushing"+str(pushed_object))

func spritedir_loop():
	match motion:
		Vector2(-1,0):
			spritedir = "left"
		Vector2(1,0):
			spritedir = "right"

func get_pushed_object(ray):
	if ray.is_colliding():
		var object = ray.get_collider()
		if object != null && object.has_method("push"):
			return object
	return null

	#keys = min(key, 3)
	
	#if is_on_wall():
		#var hitCount = get_slide_count()
	#if hitCount > 0:
		#var collision = get_slide_collision(0)
		#if collision.collider is RigidBody2D:
			#collision.collider.add_central_force(Vector2(target_speed * 20, 0))



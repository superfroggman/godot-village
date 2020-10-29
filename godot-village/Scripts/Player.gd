extends KinematicBody2D


# Declare member variables here. Examples:
export var speed = 5


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2()
	
	var deadZone = 0.2
	if Input.get_connected_joypads().size() > 0:
		var xAxis = Input.get_joy_axis(0,JOY_AXIS_0)
		var yAxis = Input.get_joy_axis(0,JOY_AXIS_1)
		if abs(xAxis) > deadZone:
			velocity.x = xAxis
		if abs(yAxis) > deadZone:
			velocity.y = yAxis
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		
	velocity.x = clamp(velocity.x, -1, 1)
	velocity.y = clamp(velocity.y, -1, 1)
	
	#if velocity.length() > 0:
	#	velocity = velocity.normalized() * speed
		
	velocity*=speed
	
	move_and_collide(velocity, true, true, false)
	
	position += velocity * delta

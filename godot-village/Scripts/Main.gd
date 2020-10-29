extends Node2D


# Declare member variables here. Examples:
export var gridSize = 32
export (PackedScene) var Floor
export (PackedScene) var Wall


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		print("Mouse Click/Unclick at: ", event.position)
		
		var pos = Vector2()
		print(event.position.x + $Player.position.x * $Player/Camera2D.zoom.x + get_viewport_rect().size.x)
		#pos.x = gridSize * round((event.position.x + $Player.position.x * $Player/Camera2D.zoom.x) + get_viewport_rect().size.x/gridSize)
		#pos.y = gridSize * round((event.position.y + $Player.position.y * $Player/Camera2D.zoom.y) + get_viewport_rect().size.y/gridSize)
		
		print((get_viewport_rect().size.x/2))
		pos.x = ($Player.position.x + event.position.x - get_viewport_rect().size.x/2)
		pos.y = ($Player.position.y + event.position.y - get_viewport_rect().size.y/2)
		
		if(event.is_action_pressed("mouse_left")):
			print("ah")
			var myFloor = Floor.instance()
			myFloor.position = pos
			add_child(myFloor)
		elif(event.is_action_pressed("mouse_right")):
			var wall = Wall.instance()
			wall.position = pos
			add_child(wall)

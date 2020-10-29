extends Node2D


# Declare member variables here. Examples:
export var gridSize = 64
export (PackedScene) var Floor
export (PackedScene) var Wall


var width = 100
var height = 100
var matrix = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(width):
		matrix.append([])
		for y in range(height):
			matrix[x].append(0)

			
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		
		var gridPos = Vector2()
		gridPos.x = round(($Player.position.x + event.position.x - get_viewport_rect().size.x/2)/gridSize)
		gridPos.y = round(($Player.position.y + event.position.y - get_viewport_rect().size.y/2)/gridSize)
		
		if(event.is_action_pressed("mouse_left")):
			if(!matrix[gridPos.x][gridPos.y]):
				var myFloor = Floor.instance()
				myFloor.position = gridPos*gridSize
				matrix[gridPos.x][gridPos.y] = myFloor
				add_child(myFloor)
		elif(event.is_action_pressed("mouse_right")):
			if(matrix[gridPos.x][gridPos.y]):
				matrix[gridPos.x][gridPos.y].queue_free()




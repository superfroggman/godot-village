extends Node2D


# Declare member variables here. Examples:
export var gridSize = 64
export(Array, PackedScene) var blocks

var width = 100
var height = 100
var matrix = []

var currentBlockType = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(width):
		var col = []
		col.resize(height)
		matrix.append(col)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#Change block type
	if(Input.is_action_just_pressed("blockNext")):
		currentBlockType += 1
	if(Input.is_action_just_pressed("blockPrev")):
		currentBlockType -= 1
	currentBlockType = clamp(currentBlockType, 0, blocks.size()-1)
	

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		placeblocks(event)


func placeblocks(event):
	var gridPos = Vector2()
	
	#Snap to grid
	gridPos.x = round(($Player.position.x + event.position.x - get_viewport_rect().size.x/2)/gridSize)
	gridPos.y = round(($Player.position.y + event.position.y - get_viewport_rect().size.y/2)/gridSize)
	
	if(event.is_action_pressed("mouse_left") && gridPos.x >= 0 && gridPos.y >= 0):
		if(!matrix[gridPos.x][gridPos.y]):
			print("x: ", gridPos.x, " y: ", gridPos.y, " cool: ", matrix[gridPos.x][gridPos.y])
			var block = blocks[currentBlockType].instance()
			block.position = gridPos*gridSize
			matrix[gridPos.x][gridPos.y] = block
			add_child(block)
	elif(event.is_action_pressed("mouse_right")):
		if(matrix[gridPos.x][gridPos.y]):
			matrix[gridPos.x][gridPos.y].queue_free()




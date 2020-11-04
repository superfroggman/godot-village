extends Node2D


# Declare member variables here. Examples:
export var gridSize = 64
export (PackedScene) var Floor
export (PackedScene) var Wall
export(Array, PackedScene) var Blocks


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
	if(Input.is_action_pressed("block1")):
		currentBlockType = 0
	if(Input.is_action_pressed("block2")):
		currentBlockType = 1
	

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		placeBlocks(event)


func placeBlocks(event):
	var gridPos = Vector2()
	gridPos.x = round(($Player.position.x + event.position.x - get_viewport_rect().size.x/2)/gridSize)
	gridPos.y = round(($Player.position.y + event.position.y - get_viewport_rect().size.y/2)/gridSize)
	
	if(event.is_action_pressed("mouse_left") && gridPos.x >= 0 && gridPos.y >= 0):
		if(!matrix[gridPos.x][gridPos.y]):
			print("x: ", gridPos.x, " y: ", gridPos.y, " cool: ", matrix[gridPos.x][gridPos.y])
			var block = Blocks[currentBlockType].instance()
			block.position = gridPos*gridSize
			matrix[gridPos.x][gridPos.y] = block
			add_child(block)
	elif(event.is_action_pressed("mouse_right")):
		if(matrix[gridPos.x][gridPos.y]):
			matrix[gridPos.x][gridPos.y].queue_free()




extends Area2D

export var gridSize = 64
export(Array, PackedScene) var blocks
export(Array, PackedScene) var roofs
export(Array, PackedScene) var objects

var width = 8
var height = 8
var placedBlocks = []
var placedRoofs = []
var placedObjects = []

var currentBlockType = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	placedBlocks = createType(placedBlocks)
	placedRoofs = createType(placedRoofs)
	placedObjects = createType(placedObjects)
	
func createType(type):
	for x in range(width):
		var col = []
		col.resize(height)
		type.append(col)
	return type


func _on_Plot_input_event(viewport, event, shape_idx):
	
	if event is InputEventMouseButton:
		var gridPos = Vector2()
		
		#Snap to grid
		gridPos.x = round(((get_global_mouse_position().x-position.x)-(gridSize/2))/gridSize)
		gridPos.y = round(((get_global_mouse_position().y-position.y)-(gridSize/2))/gridSize)
		
		if(gridPos.x >= 0 && gridPos.y >= 0 && gridPos.x < width && gridPos.y < width):
			
			if(currentBlockType < blocks.size()):
				if(event.is_action_pressed("mouse_left")):
					placedBlocks = placeBlock(placedBlocks, gridPos, blocks, currentBlockType)
				elif(event.is_action_pressed("mouse_right")):
					placedBlocks = removeBlock(placedBlocks, gridPos)
			elif(currentBlockType < blocks.size() + roofs.size()):
				if(event.is_action_pressed("mouse_left")):
					placedRoofs = placeBlock(placedRoofs, gridPos, roofs, currentBlockType - blocks.size())
				elif(event.is_action_pressed("mouse_right")):
					placedRoofs = removeBlock(placedRoofs, gridPos)
			else:
				if(event.is_action_pressed("mouse_left")):
					placedObjects = placeBlock(placedObjects, gridPos, objects, currentBlockType - blocks.size() - roofs.size())
				elif(event.is_action_pressed("mouse_right")):
					placedObjects = removeBlock(placedObjects, gridPos)
				

func placeBlock(placedBlocks, gridPos, blockList, blockIndex):
	if(!placedBlocks[gridPos.x][gridPos.y]):
		
		var block = blockList[blockIndex].instance()
		block.position = gridPos*gridSize+Vector2(32,32)
		placedBlocks[gridPos.x][gridPos.y] = block
		add_child(block)
		
	return placedBlocks

func removeBlock(placedBlocks, gridPos):
	if(placedBlocks[gridPos.x][gridPos.y]):
		placedBlocks[gridPos.x][gridPos.y].queue_free()
	return placedBlocks

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Change block type
	if(Input.is_action_just_pressed("blockNext")):
		currentBlockType += 1
	if(Input.is_action_just_pressed("blockPrev")):
		currentBlockType -= 1
	currentBlockType = clamp(currentBlockType, 0, blocks.size()+roofs.size()+objects.size()-1)




func _on_Plot_body_entered(body):
	for x in placedRoofs:
		for y in x:
			if(y):
				y.get_node("AnimationPlayer").current_animation = "FadeOut"

func _on_Plot_body_exited(body):
	for x in placedRoofs:
		for y in x:
			if(y):
				y.get_node("AnimationPlayer").current_animation = "FadeIn"

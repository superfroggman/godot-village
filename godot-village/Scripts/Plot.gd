extends Area2D

export var gridSize = 64
export(Array, PackedScene) var blocks

var width = 8
var height = 8
var placedBlocks = []
var placedRoofs = []

var currentBlockType = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(width):
		var col = []
		col.resize(height)
		placedBlocks.append(col)
	for x in range(width):
		var col = []
		col.resize(height)
		placedRoofs.append(col)


func _on_Plot_input_event(viewport, event, shape_idx):
	
	if event is InputEventMouseButton:
		var gridPos = Vector2()
		
		#Snap to grid
		gridPos.x = round(((get_global_mouse_position().x-position.x)-(gridSize/2))/gridSize)
		gridPos.y = round(((get_global_mouse_position().y-position.y)-(gridSize/2))/gridSize)
		
		if(event.is_action_pressed("mouse_left") && gridPos.x >= 0 && gridPos.y >= 0 && gridPos.x < width && gridPos.y < width):
			
			if(currentBlockType == 2):
				placedRoofs = placeBlock(placedRoofs, gridPos)
			else:
				placedBlocks = placeBlock(placedBlocks, gridPos)
				
		elif(event.is_action_pressed("mouse_right")):
			placedRoofs = removeBlock(placedRoofs, gridPos)
			placedBlocks = removeBlock(placedBlocks, gridPos)

func placeBlock(list, gridPos):
	if(!list[gridPos.x][gridPos.y]):
		
		var block = blocks[currentBlockType].instance()
		block.position = gridPos*gridSize+Vector2(32,32)
		list[gridPos.x][gridPos.y] = block
		add_child(block)
		
	return list

func removeBlock(list, gridPos):
	if(list[gridPos.x][gridPos.y]):
		list[gridPos.x][gridPos.y].queue_free()
	return list

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Change block type
	if(Input.is_action_just_pressed("blockNext")):
		currentBlockType += 1
	if(Input.is_action_just_pressed("blockPrev")):
		currentBlockType -= 1
	currentBlockType = clamp(currentBlockType, 0, blocks.size()-1)




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

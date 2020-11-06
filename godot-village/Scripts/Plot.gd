extends Area2D

export var gridSize = 64
export(Array, PackedScene) var blocks
var node = preload("res://Scenes/Node.tscn")
var blockContainer = preload("res://Scenes/BlockContainer.tscn")

var width = 8
var height = 8

var currentBlockType = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(width):
		#placedBlocks.append([])
		var column = node.instance()
		column.name = String(x)
		add_child(column)
		for y in range(height):
			var block = blockContainer.instance()
			block.name = String(y)
			get_node(String(x)).add_child(block)
			
			print("x: ", get_node(String(x)).name, " y: ", get_node(String(x)).get_node(String(y)).name)


func _on_Plot_input_event(viewport, event, shape_idx):
	
	if event is InputEventMouseButton:
		var gridPos = Vector2()
		
		#Snap to grid
		gridPos.x = round(((get_global_mouse_position().x-position.x)-(gridSize/2))/gridSize)
		gridPos.y = round(((get_global_mouse_position().y-position.y)-(gridSize/2))/gridSize)
		
		if(event.is_action_pressed("mouse_left") && gridPos.x >= 0 && gridPos.y >= 0 && gridPos.x < width && gridPos.y < width):
			
			var block = blocks[currentBlockType].instance()
			block.position = gridPos*gridSize+Vector2(32,32)
			
			if(get_node(String(gridPos.x)) && get_node(String(gridPos.x)).get_node(String(gridPos.y))):
				var container = get_node(String(gridPos.x)).get_node(String(gridPos.y))
				container.add_child(block)
			#print(placedBlocks[gridPos.x][gridPos.y].get_children())
			#print(placedBlocks[gridPos.x][gridPos.y].get_node("Roof"))
			

			
		elif(event.is_action_pressed("mouse_right")):
			#placedBlocks = removeBlock(placedBlocks, gridPos)
			pass



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



#
#func _on_Plot_body_entered(body):
#	for x in placedBlocks:
#		for y in x:
#			var roof = y.get_node("Roof")
#
#
#			if(roof):
#				var animPlayer = roof.get_node("AnimationPlayer")
#				if(animPlayer):
#					animPlayer.current_animation = "FadeOut"
#
#func _on_Plot_body_exited(body):
#	for x in placedBlocks:
#		for y in x:
#			var animPlayer = y.get_node("Roof").get_node("AnimationPlayer")
#			if(animPlayer):
#				animPlayer.current_animation = "FadeOut"

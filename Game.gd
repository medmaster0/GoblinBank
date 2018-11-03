extends Node

export (PackedScene) var Coin

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	randomize()
	
	var map_size = $FloorMapPrim.world_to_map(get_viewport().size)
	
	var map_col_1 = Color(randf(), randf(), randf())
	var map_col_2 = Color(randf(), randf(), randf())
	var map_col_3 = Color(randf(), randf(), randf())
	var map_col_4 = Color(randf(), randf(), randf())
	$FloorMapPrim.self_modulate = map_col_1
	$FloorMapSeco.self_modulate = map_col_2
	$WallMapPrim.self_modulate = map_col_3
	$WallMapSeco.self_modulate = map_col_4
	
	#Generate Map
	map_size.x = map_size.x * 2
	map_size.y = map_size.y * 2
	var map_data = RogueGen.GenerateVault_v1(map_size)
	var map = map_data.map
	var rooms = map_data.rooms

	#Cycle through the generated map (2D array)
	for x in range(map.size()):
		for y in range(map[x].size()):
			match map[x][y]:
				0:
					#blank tiles
					pass
				1:
					#floor tiles
					$FloorMapPrim.set_cell(x, y, 0)
					$FloorMapSeco.set_cell(x , y, 1)
				2:
					#wall tiles
					$WallMapPrim.set_cell(x, y, 2)
					$WallMapSeco.set_cell(x, y, 3)
					
					
	#Put a coin in each of the rooms
	for room in rooms:
		var coin_point = RogueGen.inside_rect(room)
		var coin = Coin.instance()
		coin.position = $FloorMapPrim.map_to_world(coin_point)
		add_child(coin)

	#Put the Player in a random room
	var start_room = rooms[randi()%rooms.size()]
	var room_point = RogueGen.inside_rect(start_room)
	#$FloorMapPrim/$Player.global_position = $FloorMapPrim.map_to_world(room_point)
	$FloorMapPrim/Player.position = $FloorMapPrim.map_to_world(room_point)
	
	#DEBUG: Change to different scene
	get_tree().change_scene("res://FrontOffice.tscn")
	
	
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
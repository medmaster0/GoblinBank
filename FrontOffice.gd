extends Node

export (PackedScene) var Coin

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var exchange_coins = [] #a list of coins traded at the bank
var exchange_rates = [] #a list of exchange rates. ex. 5:6:7

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	randomize()
	
	var map_size = $FloorMapPrim.world_to_map(get_viewport().size)
	
	#Random Building Colors
	var map_col_1 = Color(randf(), randf(), randf())
	var map_col_2 = Color(randf(), randf(), randf())
	var map_col_3 = Color(randf(), randf(), randf())
	var map_col_4 = Color(randf(), randf(), randf())
	var map_col_5 = Color(randf(), randf(), randf(), 0.65)#Also set alpha transparency for windows
	$WallMapPrim.self_modulate = map_col_1
	$WallMapSeco.self_modulate = map_col_2
	$FloorMapPrim.self_modulate = map_col_3
	$FloorMapSeco.self_modulate = map_col_4
	$WindowMap.self_modulate = map_col_5

	#ONly cells set with set_cell get self_modulate color
	
	#Generate Bank Layout 
	var map = RogueGen.GenerateBank(map_size)
		
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
				3:
					#Window tiles
					$FloorMapPrim.set_cell(x,y,0) #Still put a floor underneath window
					$WindowMap.set_cell(x, y, 6)
				4:
					$FloorMapPrim.set_cell(x,y,0)
					
	
	
	
	#Generate random currencies and exchange rate
	var num_currencies = randi()%3 + 6 #at least three
	for i in range(num_currencies):
		#Create the coin
		var coin = Coin.instance()
		coin.position = $FloorMapPrim.map_to_world( Vector2(5+2*i, 4) )
		add_child(coin)
		exchange_coins.append(coin)
		
		#Also create a label and exchange rate
		var rate = randi()%5 + 1 #random integer (at least 1)
		var temp_label = Label.new()
		temp_label.margin_left = coin.position.x - ($FloorMapPrim.cell_size.x/2)
		temp_label.margin_top = coin.position.y
		temp_label.text = str(rate)
		add_child(temp_label)
		#Also, possibly add a colon to text
		if i < num_currencies-1:
			var colon_label = Label.new()
			colon_label.margin_left = coin.position.x + ($FloorMapPrim.cell_size.x)
			colon_label.margin_top = coin.position.y
			colon_label.text = ":"
			add_child(colon_label)
			

#TODO:
	#random colored teller windows (color/transparency)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

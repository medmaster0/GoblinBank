extends Node

export (PackedScene) var Coin
export (PackedScene) var ZodiacTile
export (PackedScene) var Player


# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var exchange_coins = [] #a list of coins traded at the bank
var exchange_rates = [] #a list of exchange rates. ex. 5:6:7

var main_player #the main player instance

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

	#Create the new Player
	main_player = Player.instance()
	main_player.position = $FloorMapPrim.map_to_world(Vector2(20,10))
	$FloorMapPrim.add_child(main_player)

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
		exchange_rates.append(rate)
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
			
	
	#Create rope line
	$WallMapPrim.set_cell(18,16,8)
	$WallMapSeco.set_cell(18,16,7)
	$WallMapPrim.set_cell(18,17,8)
	$WallMapSeco.set_cell(18,17,7)
	$WallMapPrim.set_cell(18,18,8)
	$WallMapSeco.set_cell(18,18,7)
	$WallMapPrim.set_cell(18,19,8)
	$WallMapSeco.set_cell(18,19,7)
	$WallMapPrim.set_cell(18,20,8)
	$WallMapSeco.set_cell(18,20,7)
	$WallMapPrim.set_cell(18,21,8)
	$WallMapSeco.set_cell(18,21,7)
	$WallMapPrim.set_cell(18,22,8)
	$WallMapSeco.set_cell(18,22,7)
	$WallMapPrim.set_cell(18,23,8)
	$WallMapSeco.set_cell(18,23,7)
	$WallMapPrim.set_cell(18,24,8)
	$WallMapSeco.set_cell(18,24,7)
	$WallMapPrim.set_cell(18,25,8)
	$WallMapSeco.set_cell(18,25,7)
	$WallMapPrim.set_cell(18,26,8)
	$WallMapSeco.set_cell(18,26,7)
	$WallMapPrim.set_cell(18,27,8)
	$WallMapSeco.set_cell(18,27,7)
	
	$WallMapPrim.set_cell(23,16,8)
	$WallMapSeco.set_cell(23,16,7)
	$WallMapPrim.set_cell(23,17,8)
	$WallMapSeco.set_cell(23,17,7)
	$WallMapPrim.set_cell(23,18,8)
	$WallMapSeco.set_cell(23,18,7)
	$WallMapPrim.set_cell(23,19,8)
	$WallMapSeco.set_cell(23,19,7)
	$WallMapPrim.set_cell(23,20,8)
	$WallMapSeco.set_cell(23,20,7)
	$WallMapPrim.set_cell(23,21,8)
	$WallMapSeco.set_cell(23,21,7)
	$WallMapPrim.set_cell(23,22,8)
	$WallMapSeco.set_cell(23,22,7)
	$WallMapPrim.set_cell(23,23,8)
	$WallMapSeco.set_cell(23,23,7)
	$WallMapPrim.set_cell(23,24,8)
	$WallMapSeco.set_cell(23,24,7)
	$WallMapPrim.set_cell(23,25,8)
	$WallMapSeco.set_cell(23,25,7)
	$WallMapPrim.set_cell(23,26,8)
	$WallMapSeco.set_cell(23,26,7)
	$WallMapPrim.set_cell(23,27,8)
	$WallMapSeco.set_cell(23,27,7)
	
	#Generate Customers...
	newCustomer(  $FloorMapPrim.map_to_world( Vector2(20,16)  ) )
	newCustomer(  $FloorMapPrim.map_to_world( Vector2(20,17)  ) )
	newCustomer(  $FloorMapPrim.map_to_world( Vector2(20,18)  ) )
	newCustomer(  $FloorMapPrim.map_to_world( Vector2(20,19)  ) )
	newCustomer(  $FloorMapPrim.map_to_world( Vector2(20,20)  ) )
	newCustomer(  $FloorMapPrim.map_to_world( Vector2(20,21)  ) )
	newCustomer(  $FloorMapPrim.map_to_world( Vector2(20,22)  ) )
#	newCustomer(  $FloorMapPrim.map_to_world( Vector2(20,23)  ) )
#	newCustomer(  $FloorMapPrim.map_to_world( Vector2(20,24)  ) )
#	newCustomer(  $FloorMapPrim.map_to_world( Vector2(20,25)  ) )
#	newCustomer(  $FloorMapPrim.map_to_world( Vector2(20,26)  ) )
#	newCustomer(  $FloorMapPrim.map_to_world( Vector2(20,27)  ) )
	

#TODO:
	#random colored teller windows (color/transparency)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

#Function to create a new creature, coins, and sign
#At the given input location
func newCustomer(location):
	
	#create the creature
	var creature = Player.instance()
	creature.isCustomer = true
	creature.position = location
	$FloorMapPrim.add_child(creature)
	
	#Set the coins....
	var currency_type = randi()%exchange_coins.size() #Pick a coin position
	var multiple = randi()%7 + 1
	creature.coin.get_child(0).modulate = exchange_coins[currency_type].get_child(0).modulate
	creature.coin.get_child(1).modulate = exchange_coins[currency_type].get_child(1).modulate
	creature.coin.visible = true

	#Set the coin label
	creature.coin_label.text = str(multiple * exchange_rates[currency_type] )
	creature.get_child(2).visible = true

	#Set the zodiac tile
	creature.zodiac_tile.visible = true
	creature.get_child(3).visible = true



			
			
			
			
			
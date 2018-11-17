extends Node

export (PackedScene) var Coin
export (PackedScene) var ZodiacTile
export (PackedScene) var Player
export (PackedScene) var SpeechRequest

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var exchange_coins = [] #a list of coins traded at the bank
var exchange_rates = [] #a list of exchange rates. ex. 5:6:7
var map_coins = [] #list of coins that appear on map (with hit boxes)

var main_player #the main player instance
var speech_bubble

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
		
		#Finally, create a copy and hit box in the bank
		#The coin...
		var map_coin = Coin.instance()
		map_coin.position = $FloorMapPrim.map_to_world( Vector2(15+2*i, 6) )
		add_child(map_coin)
		map_coin.get_child(0).modulate = coin.get_child(0).modulate 
		map_coin.get_child(1).modulate = coin.get_child(1).modulate 
		map_coins.append(map_coin)
		#(NOT USING HITBOXES)
	
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
	
	#DEBUG: Try Speech Bubble
	speech_bubble = SpeechRequest.instance()
	add_child(speech_bubble)
	speech_bubble.position = $FloorMapPrim.map_to_world( Vector2(19,13) )
	#Skew the speech_bubble further
	speech_bubble.position.y = speech_bubble.position.y + ($FloorMapPrim.cell_size.y/2.0)
	speech_bubble.position.x = speech_bubble.position.x - ($FloorMapPrim.cell_size.x/2.0)
	
	#DEBUG: Color the speech bubble
	#Choose a random exchange coin
	var temp_coin = exchange_coins[randi()%exchange_coins.size()]
	speech_bubble.get_child(1).get_child(0).modulate = temp_coin.get_child(0).modulate
	speech_bubble.get_child(1).get_child(1).modulate = temp_coin.get_child(1).modulate
	
	#Generate Customers...
	newCustomer(  $FloorMapPrim.map_to_world( Vector2(20,15)  ) )
	newCustomer(  $FloorMapPrim.map_to_world( Vector2(20,17)  ) )
	newCustomer(  $FloorMapPrim.map_to_world( Vector2(20,18)  ) )
	newCustomer(  $FloorMapPrim.map_to_world( Vector2(20,19)  ) )
	newCustomer(  $FloorMapPrim.map_to_world( Vector2(20,20)  ) )
	newCustomer(  $FloorMapPrim.map_to_world( Vector2(20,21)  ) )
	newCustomer(  $FloorMapPrim.map_to_world( Vector2(20,22)  ) )
	newCustomer(  $FloorMapPrim.map_to_world( Vector2(20,23)  ) )
	newCustomer(  $FloorMapPrim.map_to_world( Vector2(20,24)  ) )
	newCustomer(  $FloorMapPrim.map_to_world( Vector2(20,25)  ) )
	newCustomer(  $FloorMapPrim.map_to_world( Vector2(20,26)  ) )
#	newCustomer(  $FloorMapPrim.map_to_world( Vector2(20,27)  ) )

	#DEBUG SEARCH TEST
	#main_player.path = $FloorMapPrim.find_path(main_player.position, map_coins[2].position)
	

#TODO:
	#random colored teller windows (color/transparency)

func _process(delta):
	# Called every frame. Delta is time since last frame.
	#EVERY FRAME EVERY FRAME
	# Update game logic here.
	
	#if the player is currently not walking a path... (reached destinatioin
	if main_player.path.size() == 0:
		#Cycle through all map_coins and check if they collide with main player
		for map_coin in  map_coins:
			if map_coin.position == main_player.position:
				#If collide, gather a new coin for the player...
				#Should be a new function
				grabCoin(map_coin)
		#Check if main_player is at customer
		var counter_position = $FloorMapPrim.get_child(1).position+Vector2(0,-3*$FloorMapPrim.cell_size.y)
		if main_player.position == counter_position:
			#DIDNT ACTUALLY NEED TIMER< BUT KEEP IT HERE FOR FUTURE REF
#			var t = Timer.new()
#			t.set_wait_time(5)
#			t.set_one_shot(true)
#			add_child(t)
#			t.start()
#			yield(t, "timeout")
#			t.queue_free()
#			print("dont time")
			#end timer
			print("rech")
			payCustomer()
			moveLineUp()

		#Determine if it should go back to window or get more coin
		if hasCashExchange() == true:
			#Walk back to customer
			counter_position = $FloorMapPrim.get_child(1).position+Vector2(0,-3*$FloorMapPrim.cell_size.y)
			main_player.path = $FloorMapPrim.find_path(main_player.position, counter_position)
		else:
			#Get path to the coin the customer REQUESTS
			var target_coin_index = whichExchangeIndex(speech_bubble.get_child(1))
			main_player.path = $FloorMapPrim.find_path(main_player.position, map_coins[target_coin_index].position)
	
	pass

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
	creature.coin_label.visible = true
	creature.get_child(2).visible = true

	#Set the zodiac tile
	creature.zodiac_tile.visible = true
	creature.get_child(3).visible = true

#Function that gathers a new coin for the player 
#("grabs" from the coin pile)
func grabCoin(grabbed_coin):
	
	#Move back a step
	main_player.position.y = main_player.position.y  + $FloorMapPrim.cell_size.y

	#Turn on and color the player's coin "background"
	main_player.get_child(2).modulate = $FloorMapPrim.self_modulate
	main_player.get_child(2).visible = true
	
	#Determine the proper coin_label (the amount of coins there are)
	#If colors are the same, then it means we aren't switching types
	#(and thusly incrementing our counter, not resetting it)
	if main_player.coin.get_child(0).modulate == grabbed_coin.get_child(0).modulate \
	and main_player.coin.get_child(1).modulate == grabbed_coin.get_child(1).modulate:
		var count = int(main_player.coin_label.text)
		count = count + 1
		main_player.coin_label.text = str(count)
	else:
		main_player.coin_label.text = "1"
	
	main_player.coin_label.visible = true
	
	#Color the player's hidden coin and make visible
	main_player.coin.get_child(0).modulate = grabbed_coin.get_child(0).modulate
	main_player.coin.get_child(1).modulate = grabbed_coin.get_child(1).modulate
	main_player.coin.visible = true
	
#Check if the label of the main_player 
#Equals the proper exchange rate criteria
#For what the customer requests
# For ex. 3y : 2x & customer has 6x, then main_player needs 9y
func hasCashExchange():
		
	#Checks global vars: exchange_rates, customer_request_speechbubble
	
	#Determine which coin the customer is asking for (find the index)
	var request_coin = speech_bubble.get_child(1)
	var request_index = whichExchangeIndex(request_coin) #the index in exchange_rates that the customer requests
	var request_rate = exchange_rates[request_index] #the actual exchange rate of what the customer WANTS
	
	#Determine the coin which the customer has and wants to exchange
	var customer_coin = $FloorMapPrim.get_child(1).coin #0 child is mainplayer, after that, customers form a queue
	var customer_index = whichExchangeIndex(customer_coin)
	var customer_rate = exchange_rates[customer_index]
	
	#Determine how many coins the customer has
	var customer_amount = $FloorMapPrim.get_child(1).coin_label.text
	customer_amount = int(customer_amount) #convert to int
	
	#Determine how many units the teller needs
	#(How many multiples of the exchange rate value)
	var units = customer_amount/customer_rate #NORMALIZED "units" on the exchange
	
	#Use units to determine how many actual coins 
	var request_amount = units * request_rate
	
	if int(main_player.coin_label.text) == request_amount:
		return true
	
	
	return false #return false if we make it down here
	
#A function that determines the *index* on the exchange of the input coin		
func whichExchangeIndex(in_coin):
	var coin_index = 0
	for exchange_coin in exchange_coins:
		if exchange_coin.get_child(0).modulate == in_coin.get_child(0).modulate && exchange_coin.get_child(1).modulate == in_coin.get_child(1).modulate:
			break
		coin_index = coin_index+1#count the coins we cycle through
		
	#coin_index now has the index of the right exchange_coin (corresponding to customers request)
	return coin_index
			

#A function for paying the customer
#Clears all labels and deuques first customer
func payCustomer():
	
	#$FloorMapPrim.get_child(1).queue_free()
	$FloorMapPrim.remove_child($FloorMapPrim.get_child(1)) #remove from scene
	main_player.coin_label.text = "0"
	main_player.coin_label.visible = false
	main_player.get_child(2).visible = false #the coin_background
	main_player.coin.visible = false

			
#TODO: MAKE A function for moving up creatures in line
#A function for moving up creatures in the line
func moveLineUp():
	
	#print($FloorMapPrim.get_children())

	#Move first customer directly up to counter
	$FloorMapPrim.get_child(1).position = $FloorMapPrim.get_child(1).position + Vector2(0,-2*$FloorMapPrim.cell_size.y)

	#For all the rest, move up one step
	$FloorMapPrim.get_child(2).position = $FloorMapPrim.get_child(2).position + Vector2(0,-1*$FloorMapPrim.cell_size.y)
	$FloorMapPrim.get_child(3).position = $FloorMapPrim.get_child(3).position + Vector2(0,-1*$FloorMapPrim.cell_size.y)
	$FloorMapPrim.get_child(4).position = $FloorMapPrim.get_child(4).position + Vector2(0,-1*$FloorMapPrim.cell_size.y)
	$FloorMapPrim.get_child(5).position = $FloorMapPrim.get_child(5).position + Vector2(0,-1*$FloorMapPrim.cell_size.y)
	$FloorMapPrim.get_child(6).position = $FloorMapPrim.get_child(6).position + Vector2(0,-1*$FloorMapPrim.cell_size.y)
	$FloorMapPrim.get_child(7).position = $FloorMapPrim.get_child(7).position + Vector2(0,-1*$FloorMapPrim.cell_size.y)
	$FloorMapPrim.get_child(8).position = $FloorMapPrim.get_child(8).position + Vector2(0,-1*$FloorMapPrim.cell_size.y)
	$FloorMapPrim.get_child(9).position = $FloorMapPrim.get_child(9).position + Vector2(0,-1*$FloorMapPrim.cell_size.y)
	$FloorMapPrim.get_child(10).position = $FloorMapPrim.get_child(10).position + Vector2(0,-1*$FloorMapPrim.cell_size.y)
	
	#And also add a new customer
	newCustomer(  $FloorMapPrim.map_to_world( Vector2(20,26)  ) )
	#New customer means new request
	#Change Speech bubble coin to random
	#Choose a random exchange coin
	var temp_coin = exchange_coins[randi()%exchange_coins.size()]
	speech_bubble.get_child(1).get_child(0).modulate = temp_coin.get_child(0).modulate
	speech_bubble.get_child(1).get_child(1).modulate = temp_coin.get_child(1).modulate
	

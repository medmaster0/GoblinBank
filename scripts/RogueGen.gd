extends Node

# Generate the Datamap
#Returns a 2D array (X,Y) of coordinates to place clouds
#array contains:
# 0 - cloud
# 2 - empty
func GenerateClouds(map_size):
	randomize()
	
#	#INitialize!
#	var map = []
#	var empty_id = 2
#	var cloud_id = 0
	
#	#Populate empty map array
#	for x in range( map_size.x ): 
#		var column = []
#		for y in range(map_size.y):
#			column.append(empty_id)
#		map.append(column)
#
#
	
	#Add a few rows of clouds
	#These are the settings
	var num_clouds = randi()%3+3
	#These are the temp variables
	var cloud_length
	var cloud_x 
	var cloud_y = int(map_size.y/4)
	#Create a list (of dictionaries for each cloud)
	var clouds = []
	
	#For each cloud we need to create...
	for cloud_iter in range( num_clouds ):
		#Roll new cloud params
		cloud_length = randi()%6+10
		cloud_x = randi()%int(2*map_size.x/3)
		#cloud_y = randi()%int(map_size.y/3) + map_size.y/3
		cloud_y = cloud_y + randi()%4 + 2
		#Add that info to the disctionary list
		clouds.append( 
			{
				"length": cloud_length,
				"x": cloud_x,
				"y": cloud_y
			}
		)
	
#	#Set map cells based on clouds
#	for cloud in clouds:
#		#Cycle acrosst length
#		for x_iter in range(cloud.length):
#			map[cloud.x+x_iter][cloud.y] = cloud_id
	
	return clouds
	
	
	
# Generate a pattern of rectangular rooms
func GenerateVault_v1(map_size):
	randomize()
	
	var map = [] #the main map (2D array) that we will return map[x][y]
	var num_rooms = 9 #How many rooms we have
	var blank_id = 0 #The ID for empty tiles
	var floor_id = 1 #The ID for Floor tiles
	var wall_id = 2 #The ID for Wall tiles
	
	
	#Initialize map 2D array
	for x in range(map_size.x):
		var column = [] #empty array
		for y in range(map_size.y):
			column.append(blank_id)
		map.append(column)
	
	#Create the rooms
	var rooms = [] #a list of room rectangles
	for room in range(num_rooms):
		#random parameters
		var length = randi()%3+5
		var x = randi()%int(map_size.x-length-2-2)+2
		var height = randi()%3+5
		var y = randi()%int(map_size.y-height-2-2)+2
		var temp_room = Rect2(x-1, y-1, length+1, height+1)
		
		#check if this room intersects any of the other ones...
		var does_intersect = false
		if !rooms.empty():
			for other_room in rooms:
				if temp_room.intersects(other_room):
					does_intersect = true
					print("inter")
					
		if does_intersect == false:
			#But if we made it here, it didn't intersect, so add it
			rooms.append(temp_room)
			
			#Carve out the room
			for tx in range(length):
				for ty in range(height):
					#Set the proper codes
					map[x+tx][y+ty] = floor_id
					
			#Also do the walls
			#TOP WALL & BOTTOM
			for tx in range(length+2):
				map[x+tx-1][y-1] = wall_id
				map[x+tx-1][y+height] = wall_id
			#LEFT AND RIGHTY
			for ty in range(height+1):
				map[x-1][y+ty-1] = wall_id
				map[x+length][y+ty-1] = wall_id

	#Create a path between the rooms
	var counter = 0
	for room in rooms:

		var random_point = inside_rect(room)
		#map[random_point.x][random_point.y] = 0
		var random_point2 = inside_rect(rooms[counter-1])
		#map[random_point2.x][random_point2.y] = wall_id

		#Now we can either go:
		var rand_choice = randi()%2
		match rand_choice:
			0:
				#Horizontal first, then vertical
				map = h_path(random_point.x, random_point2.x, random_point.y, map)
				map = v_path(random_point.y, random_point2.y, random_point2.x, map)
				
				#We need to ensure the "elbow joints" of the two paths are covered in walls	
				#Occurs at [random_point2.x][random_point.y]
				if map[random_point2.x-1][random_point.y-1] != floor_id:
					map[random_point2.x-1][random_point.y-1] = wall_id
					
				if map[random_point2.x+1][random_point.y+1] != floor_id:
					map[random_point2.x+1][random_point.y+1] = wall_id
					
				if map[random_point2.x-1][random_point.y+1] != floor_id:
					map[random_point2.x-1][random_point.y+1] = wall_id
					
				if map[random_point2.x+1][random_point.y-1] != floor_id:
					map[random_point2.x+1][random_point.y-1] = wall_id
				
				
				
				
			1:
				#Vertical first, then vertical
				map = v_path(random_point.y, random_point2.y, random_point.x, map)
				map = h_path(random_point.x, random_point2.x, random_point2.y, map)
				
				#We need to ensure the "elbow joints" of the two paths are covered in walls	
				#Occurs at [random_point.x][random_point2.y]
				if map[random_point.x-1][random_point2.y-1] != floor_id:
					map[random_point.x-1][random_point2.y-1] = wall_id
					
				if map[random_point.x+1][random_point2.y+1] != floor_id:
					map[random_point.x+1][random_point2.y+1] = wall_id
					
				if map[random_point.x-1][random_point2.y+1] != floor_id:
					map[random_point.x-1][random_point2.y+1] = wall_id
					
				if map[random_point.x+1][random_point2.y-1] != floor_id:
					map[random_point.x+1][random_point2.y-1] = wall_id

				
				
				
			
		
		counter = counter + 1
		
	var map_data = {
		
		"map": map,
		"rooms": rooms
		
		}
	
	return(map_data)
	
#Find a random point in a rectangle
func inside_rect(rect):
	var rx = rect.position.x + randi()%int(rect.size.x-1) + 1
	var ry = rect.position.y + randi()%int(rect.size.y-1) + 1
	var return_vect = Vector2(rx,ry)
	return(return_vect)
	
#Carve out a path (walls and floors) of a horizontal line in the given map
func h_path(x1, x2, y, map):
	
	#Check to make sure they are ordered correctly
	if(x1>x2):
		var temp_x = x2
		x2 = x1
		x1 = temp_x
		
	#Go through and fill out the points
	for i in range(x1,x2+1):
		#Set cell
		map[i][y] = 1
		
		#Possibly make the surrounding tiles walls
		#As long as it's not a floor
		if map[i][y-1] != 1:
			map[i][y-1] = 2
		if map[i][y+1] != 1:
			map[i][y+1] = 2
		
	return(map)
	
#Carve out a path (walls and floors) of a horizontal line in the given map
func v_path(y1, y2, x, map):
	
	#Check to make sure they are ordered correctly
	if(y1>y2):
		var temp_y = y2
		y2 = y1
		y1 = temp_y
	
	#Go through and fill out the points
	for i in range(y1,y2+1):
		
		map[x][i] = 1
		
		#Possibly make the surrounding tiles walls
		#As long as it's not a floor
		if map[x-1][i] != 1:
			map[x-1][i] = 2
		if map[x+1][i] != 1:
			map[x+1][i] = 2
		
	return(map)
	
	
#Generate Bank Layout
func GenerateBank(map_size):
	randomize()
	
	var map = [] #the main map (2D array) that we will return map[x][y]
	var num_rooms = 9 #How many rooms we have
	var blank_id = 0 #The ID for empty tiles
	var floor_id = 1 #The ID for Floor tiles
	var wall_id = 2 #The ID for Wall tiles
	var window_id = 3 #The ID for Window tiles
	var back_floor_id = 4 #A different ID for floors of a different color
	
	#Initialize map 2D array
	for x in range(map_size.x):
		var column = [] #empty array
		for y in range(map_size.y):
			column.append(blank_id)
		map.append(column)
		
	#Determine starting point of room rect
	var x0 = 10
	var y0 = 15
	var width = 40
	var height = 15
	#Determine a random window pattern
	var window_interval = randi()%6 + 1 + 1 #how often windows appear
	#var window_run = randi()%window_interval + 1 #how long the window will be
	var window_run = window_interval - 1 #how long the window will be
	# oXXoXXoXXo - interval: 3 run: 2
	# oXoooXoooX - interval: 4 run: 1
	
	#Set the floor space
	for i in range(width):
		for j in range(height):
			map[x0+i][y0+j] = floor_id
			
	#Put a row for counter (walls)
	for i in range(width):
		map[x0+i][y0-1] = wall_id
	
	#Put some floor space behind the counter
	for i in range(width):
		for j in range(7):
			map[x0+i][y0-j-3] = back_floor_id
	
	#Put a random window pattern
	#(start with a row of wall)
	for i in range(width):
		map[x0+i][y0-2] = wall_id
	#Then carve out the window tiles
	for i in range(width):
		if i%window_interval==0: #Every interval start a window
			for r in range(window_run):
				if i+r < width: #make sure it doesn't extend bounds of width
					map[x0+i+r][y0-2] = window_id

	
	
	
	return map
	
extends TileMap

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

#A* Path Finding 
#returns an array of steps to follow between the two points
#returns (9999,9999) if no path 
#input two vectors you want to search for (global non-tilemap coords)
#
#How it works:
#We have two sets, open and closed set


func find_path(global_start, global_end):
	
	#Function vars
	var open_set = []
	var closed_set = []
	var walkable_tiles = [0,1]
	
	#Convert the coordinates to map_coords
	var start = world_to_map(global_start)
	var end = world_to_map(global_end)

	#Create the FIRST node
	var temp_node = {
		"g" : 0,
		"h" : abs(start.x - end.x) + abs(start.y - end.y),
		"f" : abs(start.x - end.x) + abs(start.y - end.y),
		"coords" : start,
		"last_node" : null
	}
	#And add it to the open_set
	open_set.append(temp_node)
	
	#Now an infinite loop that only breaks once we find our target...
	while(true):
		
		#EACH ITERATION...
		#find the node in open_set with the least f (next node)
		var least_f = 9999 #temp var to keep track of what the lowest f is
		var next_node #the temp var for the node that has the lowest f
		for node in open_set:
			if node.f <= least_f: #use equals so we get the last one checked (added to open set)
				next_node = node
				least_f = node.f
		#next_node now points to the node with the lowest f
		
		#remove that node from open_set (so we don't check it again)
		open_set.erase(next_node)
		
		#Now, add each of next_node's neighbors (if walkable)
		#RIGHT
		if get_cell(next_node.coords.x+1, next_node.coords.y) in walkable_tiles:
			#Make a new node (with calculations) and add to set
			var temp_x = next_node.coords.x+1
			var temp_y = next_node.coords.y
			if Vector2(temp_x,temp_y) == end: #check if reached target
				return( path_from_set(next_node) )
				break
				
			#Check if node coords have already been entered in closed_set
			if isVectorInSet(Vector2(temp_x,temp_y), closed_set) == false: #If not closed yet
				#Then add a new node for those coords
				var neighbor_node = {
					"g" : next_node.g + 1,
					"h" : abs(end.x - temp_x) + abs(end.y - temp_y), #Manhattan Distance"
					"f" : "not set yet",
					"coords" : Vector2(temp_x, temp_y),
					"last_node" : next_node
				}
				neighbor_node.f = neighbor_node.g + neighbor_node.h #Now calculate f
				open_set.append(neighbor_node)
			
		#LEFT
		if get_cell(next_node.coords.x-1, next_node.coords.y) in walkable_tiles:
			#Make a new node (with calculations) and add to set
			var temp_x = next_node.coords.x-1
			var temp_y = next_node.coords.y
			if Vector2(temp_x,temp_y) == end: #check if reached target
				return( path_from_set(next_node) )
				break
				
			#Check if node coords have already been entered in closed_set
			if isVectorInSet(Vector2(temp_x,temp_y), closed_set) == false: #If not closed yet
				#Then add a new node for those coords
				var neighbor_node = {
					"g" : next_node.g + 1,
					"h" : abs(end.x - temp_x) + abs(end.y - temp_y), #Manhattan Distance"
					"f" : "not set yet",
					"coords" : Vector2(temp_x, temp_y),
					"last_node" : next_node
				}
				neighbor_node.f = neighbor_node.g + neighbor_node.h #Now calculate f
				open_set.append(neighbor_node)
			
		#UP
		if get_cell(next_node.coords.x, next_node.coords.y-1) in walkable_tiles:
			#Make a new node (with calculations) and add to set
			var temp_x = next_node.coords.x
			var temp_y = next_node.coords.y-1
			if Vector2(temp_x,temp_y) == end: #check if reached target
				return( path_from_set(next_node) )
				break
				
			#Check if node coords have already been entered in closed_set
			if isVectorInSet(Vector2(temp_x,temp_y), closed_set) == false: #If not closed yet
				#Then add a new node for those coords
				var neighbor_node = {
					"g" : next_node.g + 1,
					"h" : abs(end.x - temp_x) + abs(end.y - temp_y), #Manhattan Distance"
					"f" : "not set yet",
					"coords" : Vector2(temp_x, temp_y),
					"last_node" : next_node
				}
				neighbor_node.f = neighbor_node.g + neighbor_node.h #Now calculate f
				open_set.append(neighbor_node)
			
		#DOWN
		if get_cell(next_node.coords.x, next_node.coords.y+1) in walkable_tiles:
			#Make a new node (with calculations) and add to set
			var temp_x = next_node.coords.x
			var temp_y = next_node.coords.y+1
			if Vector2(temp_x,temp_y) == end: #check if reached target
				return( path_from_set(next_node) )
				break
				
			#Check if node coords have already been entered in closed_set
			if isVectorInSet(Vector2(temp_x,temp_y), closed_set) == false: #If not closed yet
				#Then add a new node for those coords
				var neighbor_node = {
					"g" : next_node.g + 1,
					"h" : abs(end.x - temp_x) + abs(end.y - temp_y), #Manhattan Distance"
					"f" : "not set yet",
					"coords" : Vector2(temp_x, temp_y),
					"last_node" : next_node
				}
				neighbor_node.f = neighbor_node.g + neighbor_node.h #Now calculate f
				open_set.append(neighbor_node)
			
		#Finally, add the node to the closed set
		closed_set.append(next_node)
			
	#end while - If this while broke, means we found target
	

#A utility function for A* that will reconstruct the path from given node
#Returns a list of steps only 
#array of Vector2
func path_from_set(latest_node):
	
	var path_array = [] #The list of coords we'll be returning back
	
	var current_node = latest_node #temp node for interating list
	while(current_node.last_node != null):
		path_array.push_front(current_node.coords)
		current_node = current_node.last_node
		
	return(path_array)
		

#Checks if the input coords (Vector2) have already been entered in the search set
func isVectorInSet(search_coords, search_set):
	
	#Iterate through all the nodes in set
	for node in search_set:
		if search_coords == node.coords: #If the coords match the target
			return(true)
	
	#If it makes it here, not in set
	return(false)
	
	
	
	
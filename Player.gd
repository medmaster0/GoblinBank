extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var map = get_parent()

#GOBLIN BANK VARS??
var zodiac_sign = randi()%12
var isCustomer = false

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	randomize()
	
	#Make a random color
	$SpriteSeco.set_modulate( Color(randf(), randf(), randf()) )
	
	#Enable user input
	set_process_input( true )
	

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


# Get our position in Map Coordinates
func get_map_pos():
	return map.world_to_map( global_position )

# Set our position to Map Coordinates
func set_map_pos( cell ):
	position = map.map_to_world( cell ) 

#Check if a tile is a floor (in the parent TIleMap)
func is_floor(cell):
	#return true
	return map.get_cellv(cell) == 0 || map.get_cellv(cell) == 1

#Step according to the input (unit) vector
func step(dir):
	#calculate new cell
	var new_cell = get_map_pos() + dir
	
	#Check if it's a valid step
	if is_floor(new_cell) == true:
		set_map_pos(new_cell)
	else:
		pass

func _input( event ):
	
	#Do nothing if it's a customer
	if isCustomer == true:
		return 
	
	# Input
    # Step Actions
	if event.is_action_pressed("ui_up"):
		step( Vector2( 0, -1 ) )
	if event.is_action_pressed("ui_down"):
		step( Vector2( 0, 1 ) )
	if event.is_action_pressed("ui_left"):
		step( Vector2( -1, 0 ) )
	if event.is_action_pressed("ui_right"):
		step( Vector2( 1, 0 ) )
	
	
	
	
	
	
	
	
	
	
	
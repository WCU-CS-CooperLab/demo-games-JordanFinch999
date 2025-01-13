extends Marker2D

@export var players_scene = preload("res://08.designing-online-platformer/Actors/Player/Player2D.tscn")


func _ready():
	if Input.get_connected_joypads().size() < 1:
		var player = players_scene.instantiate()
		add_child(player)
		return
	for i in Input.get_connected_joypads():
		var player = players_scene.instantiate()
		add_child(player)
		player.setup_controller(i)
	

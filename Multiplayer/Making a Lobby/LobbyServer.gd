extends Control
const PORT = 9999
@export var database_file_path = "res://02.sending-and-receiving-data/FakeDatabase.json"
var peer = ENetMultiplayerPeer.new()
var database = {}
var logged_users = {}

		
func _ready():
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	print("Server started and listening on port ", PORT)
	load_database()
	print("Database loaded: ", database)
	rpc_id(get_multiplayer_authority(), "retrieve_avatar",AuthenticationCredentials.user,AuthenticationCredentials.session_token)

func load_database(path_to_database_file =database_file_path):
	var file = FileAccess.open(path_to_database_file,FileAccess.READ)
	var file_content = file.get_as_text()
	database = JSON.parse_string(file_content)

	
@rpc("any_peer", "call_remote")
func authenticate_player(user, password):
	print("Server received credentials: ", user, password)
	var peer_id = multiplayer.get_remote_sender_id()
	if not user in database:
		rpc_id(peer_id, "authentication_failed","User doesn't exist")
	elif database[user]['password'] == password:
		print("Authentication successful for user: ", user)
		var token = randi()
		logged_users[user] = token
		rpc_id(peer_id, "authentication_succeed", token)
		print("Received authentication request for user: ", user)
	else:
		print("Incorrect password.")
		rpc_id(peer_id, "authentication_failed", "Incorrect password")

@rpc("any_peer", "call_remote")
func retrieve_avatar(user, session_token):
	if not user in logged_users:
		return
	if session_token == logged_users[user]:
		rpc("clear_avatars")
		for logged_user in logged_users:
			var avatar_name = database[logged_user]['name']
			var avatar_texture_path = database[logged_user]['avatar']
			rpc("add_avatar", avatar_name,avatar_texture_path)

@rpc("any_peer", "call_remote")
func test_rpc():
	print("Server received test_rpc.")

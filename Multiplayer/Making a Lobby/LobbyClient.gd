extends Control

const ADDRESS = "127.0.0.1"
const PORT = 9999

@export var avatar_card_scene = preload("res://03.making-lobby-to-gather-players/AvatarCard.tscn")

@onready var avatar_card_container = $AvatarCardsScrollContainer/AvatarCardsHBoxContainer

var peer = ENetMultiplayerPeer.new()



func _ready():
	peer.create_client(ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer
	print("Sending test_rpc to server.")
	rpc_id(get_multiplayer_authority(), "test_rpc")

@rpc
func add_avatar(avatar_name, texture_path):
	var avatar_card = avatar_card_scene.instantiate()
	avatar_card_container.add_child(avatar_card)
	await(get_tree().process_frame)
	avatar_card.update_data(avatar_name, texture_path)

@rpc
func clear_avatars():
	for child in avatar_card_container.get_children():
		child.queue_free()


@rpc("any_peer", "call_remote")
func retrieve_avatar(user, session_token):
	print("Requesting avatars for user: ", user)
	rpc_id(get_multiplayer_authority(), "retrieve_avatar", user, session_token)


@rpc("any_peer", "call_remote")
func authenticate_player(user, password):
	print("Re-authenticating player: ", user)
	rpc_id(get_multiplayer_authority(), "authenticate_player", user, password)


@rpc
func authentication_failed(error_message):
	print("Authentication failed: ", error_message)

@rpc
func authentication_succeed(user, session_token):
	print("Authentication succeeded for user: ", user, " with token: ", session_token)
	AuthenticationCredentials.user = user
	AuthenticationCredentials.session_token = session_token
	# Optionally retrieve avatars after successful authentication
	retrieve_avatar(user, session_token)




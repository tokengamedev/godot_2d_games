extends Node

## Signals that host has been created
signal host_created
## Signals that participant has been created
signal particpant_created
## Signals your opponent has connected (It can be host or participant)
signal opponent_connected
## Signals your opponent has disconnected (It can be host or participant)
signal opponent_disconnected

const Marker = Global.Marker
const URL := "ws://localhost"
const PORT := 8000

var player: Player = null
var opponent: Player = null

var peer :WebSocketMultiplayerPeer

# Called when the node enters the scene tree for the first time.
func init_mp() -> void:
	if not multiplayer.peer_connected.is_connected(_on_peer_connected):
		multiplayer.peer_connected.connect(_on_peer_connected)
		multiplayer.peer_disconnected.connect(_on_peer_disconnected)
		multiplayer.connected_to_server.connect(_on_connection_to_host)
		multiplayer.server_disconnected.connect(_on_host_disconnected)
		multiplayer.connection_failed.connect(_on_connection_failed)


func initialize() -> void:
	if Global.is_single_player_game():
		create_sp_players()
	else:
		init_mp()


## checks if the player is the host
func is_player_host() -> bool: return player.is_host

## check is the game is ready to launch
func ready_to_launch() -> bool:return player.is_ready and opponent.is_ready


## It will create single player game players
func create_sp_players():
	player = Player.new("Player")
	player.is_host = true
	player.is_ready = true

	opponent = Player.new("AI")
	opponent.is_human = false
	opponent.is_host = false
	opponent.is_ready = true


func create_mp_host(player_name: String):
	player = Player.new(player_name)

	peer = WebSocketMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer

	player.id = multiplayer.multiplayer_peer.get_unique_id()
	host_created.emit()


func create_mp_participant(player_name: String):

	player = Player.new(player_name, false)

	peer = WebSocketMultiplayerPeer.new()
	peer.create_client(URL + ":" + str(PORT))
	multiplayer.multiplayer_peer = peer

	player.id = multiplayer.multiplayer_peer.get_unique_id()
	particpant_created.emit()


func create_game(player_mark: Marker, opponent_mark: Marker):
	player.marker = player_mark
	opponent.marker = opponent_mark
	# Create the Game here
	GameManager.create_game(player, opponent)

@rpc("any_peer", "call_local")
func clear_players():
	disconnect_player()
	opponent = null

func disconnect_player():
	if peer != null:
		peer.close()
		multiplayer.multiplayer_peer = null
	player = null


func set_player_ready():
	player.is_ready = true
	set_opponent_ready.rpc_id(opponent.id)
	if ready_to_launch():
		GameManager.launch_game()

@rpc("call_remote", "any_peer")
func set_opponent_ready():
	opponent.is_ready = true
	if ready_to_launch():
		GameManager.launch_game()

@rpc("any_peer", "call_remote")
func set_opponent(player_dict: Dictionary):
	opponent = Player.from_dict(player_dict)
	opponent_connected.emit()


func _on_peer_connected(player_id: int):
	print("Player Connected:", player_id)
	set_opponent.rpc(player.to_dict())


func _on_peer_disconnected(player_id: int):
	print("Player Disconnected:", player_id)
	opponent = null
	opponent_disconnected.emit()

func _on_connection_to_host():
	print("Server Connected:")

func _on_host_disconnected():
	print("Server Disconnected:")
	opponent_disconnected.emit()

func _on_connection_failed():
	print("Connection failed:")

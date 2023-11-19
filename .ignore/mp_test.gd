extends Node2D

var peer = ENetMultiplayerPeer.new()
@export var player_scene: PackedScene
var IP_ADDRESS = '86.123.205.95'
var PORT = 25565
var MAX_CLIENTS = 4
# Called when the node enters the scene tree for the first time.
func _ready():
	if multiplayer.is_server():
		print_once_per_client.rpc()

@rpc
func print_once_per_client():
	print("I will be printed to the console once per each connected client.")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_host_pressed():
	peer.create_server(PORT, MAX_CLIENTS)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	_add_player()
	$host.disabled = true
	$join.disabled = true
	
func _add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)

func _on_join_pressed():
	peer.create_client(IP_ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer
	$host.disabled = true
	$join.disabled = true

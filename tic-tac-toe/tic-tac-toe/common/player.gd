## Represents a player in the game
class_name Player extends RefCounted

var name: StringName
var id: int = 0
var marker := Global.Marker.EMPTY
var is_human := true
var is_host := false
var is_ready := false

func _init(_name: StringName, _is_host := true, _is_human := true) -> void:
	name = _name
	is_human = _is_human
	is_host = _is_host

func to_dict() -> Dictionary:
	return {
		"name" : name,
		"id" : id,
		"marker" : marker as int,
		"is_human" : is_human,
		"is_host": is_host,
		"is_ready": is_ready
	}

static func from_dict(dict: Dictionary) -> Player:
	var player = Player.new(dict.name)
	player.id = dict.id
	player.marker = dict.marker as Global.Marker
	player.is_host = dict.is_host
	player.is_human = dict.is_human
	player.is_ready = dict.is_ready
	return player


func _to_string() -> String:
	return "%s(%d) - %s" % [name, id, Global.Marker.find_key(marker)]

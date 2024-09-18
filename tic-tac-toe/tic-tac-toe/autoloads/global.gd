## Global class to hold the global level variables and constants
extends Node

## Possible types of game that can be played by the player
enum GameType { WITH_AI, WITH_FRIENDS }

## Types of Markers in the game
enum Marker {EMPTY, X, O}

## Holds the type of the game currently it is running
var game_type: GameType

## Checks if the game is in single player (playing with AI)
func is_single_player_game() : return game_type == GameType.WITH_AI

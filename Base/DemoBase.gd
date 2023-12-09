extends Node

@onready var MenuScene = "res://Base/menu_inicial.tscn"

func _input(event):
	if(event.is_action_pressed("ExitDemo")):
		get_tree().change_scene_to_file(MenuScene)

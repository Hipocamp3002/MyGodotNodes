extends HFlowContainer

@export_dir var DemosDir = "res://Demos/"
@export var buttonScene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	var dir = DirAccess.open(DemosDir)
	if dir:
		# for each file
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			#create a button with that file
			var full_dir = DemosDir + file_name
			var button = buttonScene.instantiate()
			button.DemoDir = full_dir
			add_child(button)
			
			file_name = dir.get_next()



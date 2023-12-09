extends Button

@export_dir var DemoDir;

# Called when the node enters the scene tree for the first time.
func _ready():
	text = DemoDir.get_file().get_slice(".",0)



func _on_button_up():
	get_tree().change_scene_to_file(DemoDir)

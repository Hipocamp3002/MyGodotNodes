@tool
extends BreakNode


func Body_break():
	#find shape
	var Shape : Polygon2D
	
	for c in get_parent().get_children():
		if(c.get_class() == "Polygon2D"):
			Shape = c
	
	var polygon = Shape.polygon
	var Triangulation = Geometry2D.triangulate_polygon(polygon)
	
	for i in range(0,Triangulation.size(),3):
		var tri : PackedVector2Array
		tri.push_back(polygon[Triangulation[i]])
		tri.push_back(polygon[Triangulation[i+1]])
		tri.push_back(polygon[Triangulation[i+2]])
		
		add_piece(tri,Shape)
	
	get_parent().queue_free()


func _ready():
	if Engine.is_editor_hint():
		get_parent().child_order_changed.connect(update_configuration_warnings)
	else:
		pass

func  _get_configuration_warnings():
	var p = get_parent()
	if p == null: return []
	
	var has_shape = false
	for c in p.get_children():
		if(c.get_class() == "Polygon2D"):
			has_shape = true
	
	if(!has_shape): return ["Parent doesn't have a shape2D to break"]
	
	return[]

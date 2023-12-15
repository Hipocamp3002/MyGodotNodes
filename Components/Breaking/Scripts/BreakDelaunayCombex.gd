extends BreakNode

@export var nunPoints = 10
@export var min_width = 10

func Body_break():
	#find shape
	var Shape : Polygon2D
	
	for c in get_parent().get_children():
		if(c.get_class() == "Polygon2D"):
			Shape = c
	
	var polygon = Shape.polygon
	var points = polygon.duplicate()
	
	#get size polygon
	var min_vec = polygon[0]
	var max_vec = polygon[0]
	for i in range(1,polygon.size()):
		var v = polygon[i]
		if(v.x < min_vec.x): min_vec.x = v.x
		if(v.y < min_vec.y): min_vec.y = v.y
		if(v.x > max_vec.x): max_vec.x = v.x
		if(v.y > max_vec.y): max_vec.y = v.y
	
	#random points in rectangle
	var count = 0
	while(count < nunPoints):
		var x = randf_range(min_vec.x,max_vec.x)
		var y = randf_range(min_vec.y,max_vec.y)
		var v = Vector2(x,y)
		if(Geometry2D.is_point_in_polygon(v,polygon)):
			count += 1
			points.push_back(v)
	
	var Triangulation = Geometry2D.triangulate_delaunay(points)
	
	for i in range(0,Triangulation.size(),3):
		var tri : PackedVector2Array
		tri.push_back(points[Triangulation[i]])
		tri.push_back(points[Triangulation[i+1]])
		tri.push_back(points[Triangulation[i+2]])
		
		var create = true
		if(min_width > 0):
			#check thickness
			for j in 3:
				var v = tri[(j+1)%3] - tri[j]
				var u = tri[(j-1)%3] - tri[j]
				
				var c = v.dot(u)/(v.length()*u.length())
				var s = sqrt(1-c*c)
			
				if abs(s*v.length()) < min_width: create=false 
		
		if create:
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
			#TODO: Check if polygon is conbex
			
			return [""]
	return ["Parent doesn't have a shape2D to break"]



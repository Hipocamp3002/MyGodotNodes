extends BreakNode


@export var cut_pos:Vector2
@export_range(-180,180) var cut_angle:float

func  Body_break():
	var Shape : Polygon2D
	
	for c in get_parent().get_children():
		if(c.get_class() == "Polygon2D"):
			Shape = c
	
	var polygon = Shape.polygon
	
	var bound_min = polygon[0]
	var bound_max = polygon[0]
	for v in polygon:
		if v.x > bound_max.x: bound_max.x = v.x
		if v.y > bound_max.y: bound_max.y = v.y
		if v.x < bound_min.x: bound_min.x = v.x
		if v.y < bound_min.y: bound_min.y = v.y
	
	var diag = (bound_max-bound_min).length()
	
	var ang = -deg_to_rad(cut_angle)
	var cut_plane : PackedVector2Array
	cut_plane.push_back((Vector2.RIGHT).rotated(ang) * diag - cut_pos)
	cut_plane.push_back((Vector2.RIGHT + Vector2.UP).rotated(ang) * diag  - cut_pos)
	cut_plane.push_back((Vector2.LEFT + Vector2.UP).rotated(ang) * diag  - cut_pos)
	cut_plane.push_back((Vector2.LEFT).rotated(ang) * diag  - cut_pos)
	
	var in_pol = Geometry2D.intersect_polygons(polygon,cut_plane)
	var pols = []
	for p in in_pol:
		if(not Geometry2D.is_polygon_clockwise(p)):
			add_piece(p,Shape)
			pols.push_back(p)
	
	var out_pol = [polygon]
	for c in pols:
		var new_pol = []
		for p in out_pol:
			var aux = Geometry2D.exclude_polygons(p,c)
			for a in aux:
				if(not Geometry2D.is_polygon_clockwise(a)):
					new_pol.push_back(a)
		out_pol = new_pol
		print(new_pol)
	for p in out_pol:
		if(not Geometry2D.is_polygon_clockwise(p)):
			add_piece(p,Shape)
	
	get_parent().queue_free()

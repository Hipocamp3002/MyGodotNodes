extends BreakNode

@export
var cellSize : Vector2 = Vector2(50,50)

var square : PackedVector2Array

func _ready():
	var arr = [
		Vector2.ZERO,
		Vector2(cellSize.x,0),
		Vector2(cellSize.x,cellSize.y),
		Vector2(0,cellSize.y)
	]
	square = PackedVector2Array(arr)

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
	
	
	var cur_pos = bound_min
	while(cur_pos.y < bound_max.y):
		while(cur_pos.x < bound_max.x):
			var mov_sqr = square.duplicate()
			for i in mov_sqr.size(): mov_sqr[i] += cur_pos
			
			var res = Geometry2D.exclude_polygons(polygon,mov_sqr)
			var i = 0
			while(i < res.size() and not Geometry2D.is_polygon_clockwise(res[i])): i += 1
			if(i < res.size()):
				var n_pol = res[i]
				
				add_piece(n_pol,Shape)
			
			cur_pos.x += cellSize.x
		cur_pos.y += cellSize.y
		cur_pos.x = bound_min.x
	
	get_parent().queue_free()

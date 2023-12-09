extends RigidBody2D

@onready var Collision : CollisionPolygon2D
@export var Shape : Polygon2D
@export var polygon : PackedVector2Array

func set_shape(new_polygon:PackedVector2Array, new_shape:Polygon2D):
	polygon = new_polygon
	
	#find center
	var center = Vector2.ZERO
	for v in polygon:
		center += v
	center /= polygon.size()
	
	for i in range(0,polygon.size()):
		polygon[i] -= center
	
	position += center
	
	Shape = new_shape.duplicate() as Polygon2D
	Shape.polygon = polygon
	Shape.texture_offset += center.rotated(Shape.texture_rotation)
	add_child(Shape)
	
	Collision = CollisionPolygon2D.new()
	Collision.polygon = polygon
	add_child(Collision)

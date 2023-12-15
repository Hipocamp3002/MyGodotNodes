@tool
extends Node
class_name BreakNode

@export var piece : PackedScene:
	set(p):
		piece = p
		if Engine.is_editor_hint():
			update_configuration_warnings()

@export 
var explosionForce : float = 0.1;
@export var centerOffset : Vector2 = Vector2.ZERO 

func _get_configuration_warnings():
	if piece == null:
		return ["No piece to break into"]
	
	var p = piece.instantiate()
	
	if !p.has_method("set_shape"):
		return ["Piece can't be set, needs set_shape(PackedVector2Array , Polygon2D)"]
	
	return []

func add_piece(new_poligon:PackedVector2Array, Shape):
	var p = piece.instantiate()
	
	p.position = get_parent().position
	
	if(p.get_class() == "RigidBody2D"):
		var center = Vector2.ZERO
		for v in new_poligon:
			center += v
		center -= centerOffset
		(p as RigidBody2D).apply_impulse(center * explosionForce)
	
	p.set_shape(new_poligon,Shape)
	
	get_parent().add_sibling(p)

func  Body_break():
	pass

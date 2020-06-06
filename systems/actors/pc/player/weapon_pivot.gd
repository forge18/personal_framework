extends Position2D

var z_index_start := 0

func _ready() -> void:
	var _connection := $"..".connect("direction_changed", self, '_on_Actor_direction_changed')
	z_index_start = z_index


func _on_Actor_direction_changed(direction: Vector2) -> void:
	#self.rotation = direction.angle() 
	self.rotation = direction.angle()

	match direction:
		Vector2(0, -1):
			z_index = z_index_start - 1
		Vector2(-1, -1):
			z_index = z_index_start - 1
		Vector2(1, -1):	
			z_index = z_index_start - 1
		Vector2(0, 0):
			self.rotation = Vector2(0,1).angle()
		_:
			z_index = z_index_start
	

extends StaticBody2D

func _physics_process(delta) -> void:
	var player = get_node("/root/Main/Player") #ruta al Player
	if (player.position.y + 75) < position.y:
		set_collision_layer_value(2, true)
		set_collision_layer_value(3, false)
	else:
		set_collision_layer_value(2, false)
		set_collision_layer_value(3, true)

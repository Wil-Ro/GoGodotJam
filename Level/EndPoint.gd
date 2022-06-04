extends Area
signal level_end

func _ready():
	add_to_group("endPoint")


func _on_Area_body_entered(body):
	print("end!")
	emit_signal("level_end")

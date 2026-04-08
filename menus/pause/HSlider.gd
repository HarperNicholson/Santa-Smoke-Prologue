extends HSlider

func _ready():
	value = db_to_linear(AudioServer.get_bus_volume_db(0))

func _on_value_changed(changedValue: float):
	AudioServer.set_bus_volume_db(0, linear_to_db(changedValue))

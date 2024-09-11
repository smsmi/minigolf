extends CanvasLayer

func _process(delta: float) -> void:
	$Meter/Indicator.offset.x = (get_parent().power / 100) * ($Meter.texture.get_width() - 4)

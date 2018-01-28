
extends Panel

signal on_begin_drag(object)
signal on_drag(object)
signal on_end_drag(object)

var dragging = false

var preview_visibiliy = false
var preview = null

onready var initial_pos = self.get_pos()


func _input_event(event):
	# On_begin_drag detection
	if Mouse.is_pressed(event) and Mouse.is_holding_left(event):
		dragging = true
		DragHandler.set_object(self)

		create_preview()
		emit_signal("on_begin_drag", self)

	# On_drag detection
	if dragging and Mouse.is_in_motion(event):
		emit_signal("on_drag", self)

		#Move preview with mouse position
		if preview == null: return

		var offset = Vector2(get_size().x / 2, get_size().y * .75)
		preview.set_global_pos(Mouse.position - offset)

	# On_end_drag detection
	if dragging and Mouse.is_released(event):
		dragging = false
		destroy_preview()

		emit_signal("on_end_drag", self)
		DragHandler.set_object(null)


func set_preview_visible(b):
	preview_visibiliy = b


func create_preview():
	if preview == null:
		preview = self.duplicate(true)
		preview.set_opacity(.3)
		preview.show() if preview_visibiliy else preview.hide()
		get_parent().add_child(preview)


func destroy_preview():
	if preview == null: return

	preview.hide()
	get_parent().remove_child(preview)
	preview = null
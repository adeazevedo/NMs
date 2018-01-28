extends Node

var position = Vector2()
var previous_event = null


func _ready():
	set_process_input(true)
	set_process_unhandled_input(true)


func _input(event):
	position = get_viewport().get_mouse_pos()


func _unhandled_input(event):
	previous_event = event


func is_pressed (event, button = BUTTON_LEFT):
	return 	event.type == InputEvent.MOUSE_BUTTON and \
			event.button_index == button and \
			event.pressed == true


func is_released (event, button = BUTTON_LEFT):
	return	event.type == InputEvent.MOUSE_BUTTON and \
			event.button_index == button and \
			event.pressed == false


func is_click (event, button = BUTTON_LEFT):
	if previous_event == null: return false

	return is_pressed(previous_event, button) and is_released(event, button)


func is_in_motion (event):
	return 	event.type == InputEvent.MOUSE_MOTION


func is_holding_left (event):
	return 	(event.type == InputEvent.MOUSE_BUTTON or
			event.type == InputEvent.MOUSE_MOTION) and \
			event.button_mask == BUTTON_MASK_LEFT


func is_holding_right (event):
	return 	(event.type == InputEvent.MOUSE_BUTTON or
			event.type == InputEvent.MOUSE_MOTION) and \
			event.button_mask == BUTTON_MASK_RIGHT


func is_hovering (event, container):
	return container.get_global_rect().has_point(event.pos)


func exited (event, container):
	return 	is_hovering(previous_event, container) and \
			!is_hovering(event, container)


func entered (event, container):
	return 	!is_hovering(previous_event, container) and \
			is_hovering(event, container)

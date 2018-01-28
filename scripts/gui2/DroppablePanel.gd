
extends PanelContainer

signal droppable_enter(object)
signal droppable_exit(object)
signal droppable_hovering(object)
signal object_dropped(object)

var drop_point = Vector2()

var light = 0.0
var highlight_on = false
var highlight_color = Color(.7, .7, 0, 1)

var slot = null


func _ready():
	set_process_input(true)
	set_fixed_process(true)

	connect("droppable_enter", self, "start_highlight")
	connect("droppable_exit", self, "end_highlight")
	connect("object_dropped", self, "end_highlight")

# TODO: Highlight should be separated class

func _fixed_process(delta):
	if highlight_on:
		process_hightlight()
		update()


func _input(event):
	if slot != null: return
	if !DragHandler.has_object(): return
	else: end_highlight()

	var drag_obj = DragHandler.get_object()

	if Mouse.entered(event, self):
		emit_signal("droppable_enter", drag_obj)

	if Mouse.is_hovering(event, self):
		emit_signal("droppable_hovering", drag_obj)

		if Mouse.is_released(event):
			recieve_object()
			emit_signal("object_dropped", drag_obj)

	if Mouse.exited(event, self):
		emit_signal("droppable_exit", drag_obj)


func recieve_object(object = DragHandler.get_object()):
	if slot != null: return

	slot = object
	DragHandler.drop(self)

	slot.set_pos(drop_point)


func start_highlight(obj = null):
	highlight_on = true


func end_highlight(obj = null):
	highlight_on = false
	light = 0
	highlight_color.a = 0

	update()


func process_hightlight():
	var x = deg2rad(light)
	var w = .5 * sin(5 * (x - PI/2)) + .5
	var alpha = lerp(0, 1, w)
	highlight_color.a = alpha
	light += 1


func _draw():
	if !highlight_on: return

	var r = get_global_rect()

	draw_line(Vector2(), Vector2(0, r.size.x), highlight_color, 3)
	draw_line(Vector2(), Vector2(r.size.y, 0), highlight_color, 3)
	draw_line(Vector2(r.size.x, r.size.y), Vector2(0, r.size.x), highlight_color, 3)
	draw_line(Vector2(r.size.x, r.size.y), Vector2(r.size.y, 0), highlight_color, 3)
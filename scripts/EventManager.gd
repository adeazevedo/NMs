extends Node

var listeners = {}

# call (string event, Func args)
func listen(event, callback):
	if not listeners.has(event):
		listeners[event] = []

	if listeners[event].find(callback) < 0:
		listeners[event].append(callback)


# call (string event, Func args)
func ignore(event, callback):
	if listeners.has(event):
		if listeners[event].find(callback) >= 0:
			listeners[event].erase(callback)


# call (string event, object args)
func emit(event, args = []):
	if listeners.has(event):
		var callbacks = listeners[event]

		for f in callbacks:
			f.call_func(args)


func has(event, callback):
	return listeners.has(event) and listeners[event].find(callback) >= 0
extends Node2D

var queues = {}

func get_queue_by_name(name):
	if queues.has(name):
		return queues[name]
	return null

func create_queue(name):
	if !queues.has(name):
		queues[name] = []

func remove_queue(name):
	if queues.has(name):
		queues.erase(name)
	
func clear_queue(name):
	if queues.has(name):
		queues[name].clear()

func push_to_queue(queue_name, request):
	if !queues.has(queue_name):
		self.create_queue(queue_name)
		
	queues[queue_name].push_back(request)

func get_next_from_queue(queue_name):
	if queues.has(queue_name) && queues[queue_name].size() > 0:
		var request = queues[queue_name].pop_front()
		return request

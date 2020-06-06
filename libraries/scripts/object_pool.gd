extends Node2D
#
#export(NodePath) var object_to_pool_path: NodePath
#export(int) var max_pool_instances: int
#export(int) var pool_refill_amount: int
#
#var object_to_pool := null
#var pool := []
#
#func _ready() -> void:
#	object_to_pool = get_node(object_to_pool_path)
#	set_process(true)
#
#func _process(delta: float) -> void:
#	if pool.size() < max_pool_instances:
#		refill()
#	# do other stuff
#
## refilling the pool with an amount that doesn't slow down noticeably the game
#func refill() -> void:
#	for i in range(pool_refill_amount):
#		 pool.push_back(get_instance())
#
#func get_instance():
#	if pool.size() == 0: # in case pool is empty, create manually the instance
#		return object_to_pool.instance()
#	var instance = pool[0]
#	pool.pop_front()
#	return instance

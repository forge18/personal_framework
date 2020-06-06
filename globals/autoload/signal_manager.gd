extends Node

# warnings-disable


# Pathfinder Signals
signal pathfinder_get_path(actor_id, start, end)
signal pathfinder_set_path(actor_id, path)


# Steering Signals
signal steering_follow_path(path)

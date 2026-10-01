extends Node

var chains = {}

func register_chain(id, stages):
    chains[id] = stages

func get_chain(id):
    return chains.get(id, [])

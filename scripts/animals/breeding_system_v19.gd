extends Node

func can_breed(a, b):
    return a != null and b != null and a.species == b.species and a.stage == "adult" and b.stage == "adult"

func inherit_quality(parent_a, parent_b):
    return clamp((parent_a.quality_potential + parent_b.quality_potential) / 2.0, 0.0, 1.0)

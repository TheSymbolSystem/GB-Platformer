extends Node

onready var player = $KinematicBody2D

const MIN_INTERVAL = 100
const MAX_INTERVAL = 250

var current_max_interval
var current_min_interval
var last_spawn_height
var screen_size 

func _ready():
	last_spawn_height = get_viewport().get_viewport().size.y
	current_max_interval = MAX_INTERVAL
	current_min_interval = MIN_INTERVAL
	screen_size = get_viewport().get_visible_rect().size.x

func _on_Area2D_body_entered(body):
	pass # replace with function body

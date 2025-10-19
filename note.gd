extends AnimatedSprite2D

var note_scene = preload("res://scenes/note.tscn")
var clones = []

@export var startPos: Vector2
@export var direction: Vector2
 
@export var scorePos: Vector2
@export var inputs: Array

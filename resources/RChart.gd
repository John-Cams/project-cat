extends Resource
class_name Chart

@export var name: String
@export var songPath: AudioStream
@export var BPM: int
@export var noteQueue: Array[int]
@export var direction: Array[int]
@export var nextChart: Chart
@export var albumCover: Texture2D

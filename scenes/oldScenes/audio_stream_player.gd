extends AudioStreamPlayer

#https://pixabay.com/sound-effects/tr808-snare-drum-241403/
var bad = preload("res://sfx/tr808-snare-drum-241403.mp3")
#https://pixabay.com/sound-effects/ding-126626/
var good = preload("res://sfx/ding-126626.mp3")
#http://pixabay.com/sound-effects/soft-notice-146623/
var great = preload("res://sfx/soft-notice-146623.mp3")
#https://pixabay.com/sound-effects/shine-8-268901/
var perfect = preload("res://sfx/shine-8-268901.mp3")

var sounds = [bad,bad,good,good,great,great,perfect]


func _on_main_hit(score: int) -> void:
	stream = sounds[score-1]
	play()

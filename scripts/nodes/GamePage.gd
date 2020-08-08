extends Node2D

onready var game = $"/root/Game"

const BONUS_TIME_SEC = 5.0

var _default_wait_time


func _ready():
    randomize()
    $NumButtons.init()
    prepare_game()
    game.connect("dial_succeded", self, "_on_dial_succeded")
    game.connect("succeded", self, "_on_succeded")
    game.connect("failed", self, "_on_failed")
    $Timer.connect("timeout", self, "_on_timer_timeout")
    $Timer.start()
    _default_wait_time = int($Timer.wait_time)


func prepare_game():
    set_new_objective()
    game.set_max_score(10)
    game.reset_score()
    game.reset_level()


func set_new_objective():
    var objective = ""
    for i in _random_digits():
        objective += str(i)
    game.set_objective(objective)


func add_bonus_time():
    $Timer.start(clamp($Timer.time_left + BONUS_TIME_SEC, 0, $Timer.wait_time))
    $Timer.set_wait_time(_default_wait_time)


func _random_digits(num_digits: int = 4):
    var choices = [] + $NumButtons.number_choices
    var digits = []
    if num_digits > choices.size():
        num_digits = choices.size()
    for i in num_digits:
        var index = randi() % choices.size()
        digits.append(choices[index])
        choices.remove(index)
    return digits


func _on_dial_succeded():
    $NumButtons.animate_scale_up_on_last_button_pressed()


func _on_succeded():
    $Timer.set_paused(true)
    yield($NumButtons.animate_scale_up_on_last_button_pressed(), "completed")
    yield($NumButtons.animate_scale_down_on_all_buttons(), "completed")
    yield($NumButtons.animate_shuffle(), "completed")
    add_bonus_time()
    $Timer.set_paused(false)
    set_new_objective()
    game.increment_score()


func _on_failed():
    $Timer.set_paused(true)
    yield($NumButtons.animate_scale_up_on_last_button_pressed(), "completed")
    yield($NumButtons.animate_scale_down_on_all_buttons(), "completed")
    yield($NumButtons.animate_shuffle(), "completed")
    $Timer.start()
    $Timer.set_paused(false)
    set_new_objective()
    game.reset_score()
    game.reset_level()


func _on_timer_timeout():
    yield($NumButtons.animate_scale_down_on_all_buttons(), "completed")
    yield($NumButtons.animate_shuffle(), "completed")
    $Timer.start()
    set_new_objective()
    game.reset_score()
    game.reset_level()
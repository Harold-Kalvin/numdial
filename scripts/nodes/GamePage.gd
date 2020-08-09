extends Node2D

onready var game = $"/root/Game"

const BONUS_TIME_SEC = 5.0

var _default_wait_time


func _ready():
    randomize()
    $NumButtons.init()
    reset_game()
    game.connect("dial_succeded", self, "_on_dial_succeded")
    game.connect("succeded", self, "_on_succeded")
    game.connect("failed", self, "_on_failed")
    $Timer.connect("timeout", self, "_on_timer_timeout")
    $Timer.start()
    _default_wait_time = int($Timer.wait_time)


func reset_game():
    game.set_max_score(10)
    game.reset_score()
    game.reset_level()
    set_new_objective()


func set_next_game():
    game.set_max_score(10)
    game.increment_score()
    set_new_objective()


func set_new_objective():
    var objective = ""
    for i in _random_digits($NumButtons.get_number_choices()):
        objective += str(i)
    game.set_objective(objective)


func add_bonus_time():
    $Timer.start(clamp($Timer.time_left + BONUS_TIME_SEC, 0, $Timer.wait_time))
    $Timer.set_wait_time(_default_wait_time)


func _random_digits(choices: Array, num_digits: int = 4):
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
    set_next_game()

    # run animations and add bonus time on timer
    $Timer.set_paused(true)
    $NumButtons.disable_click()
    yield($NumButtons.animate_scale_up_on_last_button_pressed(), "completed")
    yield($NumButtons.animate_scale_down_on_all_buttons(), "completed")
    yield($NumButtons.animate_shuffle(), "completed")
    $NumButtons.enable_click()
    add_bonus_time()
    $Timer.set_paused(false)


func _on_failed():
    reset_game()

    # run animations and reset timer
    $Timer.set_paused(true)
    $NumButtons.disable_click()
    yield($NumButtons.animate_scale_up_on_last_button_pressed(), "completed")
    yield($NumButtons.animate_scale_down_on_all_buttons(), "completed")
    yield($NumButtons.animate_shuffle(), "completed")
    $NumButtons.enable_click()
    $Timer.start()
    $Timer.set_paused(false)


func _on_timer_timeout():
    reset_game()

    # run animations and reset timer
    $NumButtons.disable_click()
    yield($NumButtons.animate_scale_down_on_all_buttons(), "completed")
    yield($NumButtons.animate_shuffle(), "completed")
    $NumButtons.enable_click()
    $Timer.start()

extends Node2D

onready var game = $"/root/Game"

const BONUS_TIME_SEC = 5.0
const TOTAL_BUTTONS_PROGRESSION_LEVELS = [2, 3]
const TOTAL_BUTTONS_PROGRESSION = {
    0: 4,
    1: 8,
    2: 10,
}
const MAX_SCORE_PROGRESSION_LEVELS = [2, 3]
const MAX_SCORE_PROGRESSION = {
    0: 3,
    1: 4,
    2: 5,
}
const OBJECTIVE_NUMBERS_PROGRESSION_LEVELS = [2, 3, 4]
const OBJECTIVE_NUMBERS_PROGRESSION = {
    0: {"min": 2, "max": 2},
    1: {"min": 2, "max": 4},
    2: {"min": 3, "max": 5},
    3: {"min": 4, "max": 6},
}

var _default_wait_time


func _ready():
    randomize()

    # create num buttons
    $NumButtons.init(get_current_total_buttons())
    
    # set game variables (objective, level, score)
    reset_game()
    notify_game_changed()

    # connect game signals
    game.connect("dial_succeded", self, "_on_dial_succeded")
    game.connect("succeded", self, "_on_succeded")
    game.connect("failed", self, "_on_failed")

    # init timer
    $Timer.connect("timeout", self, "_on_timer_timeout")
    $Timer.start()
    _default_wait_time = int($Timer.wait_time)


func reset_game():
    game.set_max_score(get_current_max_score())
    game.reset_score()
    game.reset_level()

    # after resetting level, update list of buttons if needed
    if get_current_total_buttons() < $NumButtons.get_total():
        var buttons_to_remove = $NumButtons.get_total() - TOTAL_BUTTONS_PROGRESSION[0]
        $NumButtons.remove_buttons(buttons_to_remove)
    
    set_new_objective()


func set_next_game():
    game.set_max_score(get_current_max_score())
    game.increment_score()
    
    # after setting next level, update list of buttons if needed
    if get_current_total_buttons() > $NumButtons.get_total():
        var buttons_to_add = get_current_total_buttons() - $NumButtons.get_total() 
        $NumButtons.add_buttons(buttons_to_add, $NumButtons.get_shuffle_position())
    
    set_new_objective()


func set_new_objective():
    var objective = ""
    var allowed_digits = $NumButtons.get_number_choices()
    var objective_numbers = get_current_objective_numbers()
    for i in _random_digits(allowed_digits, objective_numbers["min"], objective_numbers["max"]):
        objective += str(i)
    game.set_objective(objective)


func notify_game_changed():
    game.emit_score_changed()
    game.emit_max_score_changed()
    game.emit_level_changed()
    game.emit_objective_changed()


func add_bonus_time():
    $Timer.start(clamp($Timer.time_left + BONUS_TIME_SEC, 0, $Timer.wait_time))
    $Timer.set_wait_time(_default_wait_time)


func get_current_total_buttons():
    return TOTAL_BUTTONS_PROGRESSION[_get_current_progression(TOTAL_BUTTONS_PROGRESSION_LEVELS)]


func get_current_max_score():
    return MAX_SCORE_PROGRESSION[_get_current_progression(MAX_SCORE_PROGRESSION_LEVELS)]


func get_current_objective_numbers():
    return OBJECTIVE_NUMBERS_PROGRESSION[_get_current_progression(OBJECTIVE_NUMBERS_PROGRESSION_LEVELS)]


func _random_digits(allowed_digits: Array, min_total_digits: int, max_total_digits: int):
    var choices = [] + allowed_digits
    var digits = []
    var digit_range = range(min_total_digits, max_total_digits + 1)
    var num_digits = digit_range[randi() % digit_range.size()]
    for i in num_digits:
        var index = randi() % choices.size()
        digits.append(choices[index])
        choices.remove(index)
    return digits


func _get_current_progression(progression_levels: Array):
    for i in progression_levels.size():
        var level_to_reach = progression_levels[i]
        if game.get_level() < level_to_reach:
            return i
    return progression_levels.size()


func _on_dial_succeded():
    $NumButtons.animate_scale_up_on_last_button_pressed()


func _on_succeded():
    # set game variables (score, objective etc.)
    set_next_game()

    # run animations and add bonus time on timer
    $NumButtons.disable_click()
    yield($NumButtons.animate_scale_up_on_last_button_pressed(), "completed")
    yield($NumButtons.animate_scale_down_on_all_buttons(), "completed")
    yield($NumButtons.animate_shuffle(), "completed")
    $NumButtons.enable_click()
    add_bonus_time()

    # emit game signals (score, objective etc.)
    notify_game_changed()


func _on_failed():
    # set game variables (score, objective etc.)
    reset_game()

    # run animations and reset timer
    $NumButtons.disable_click()
    yield($NumButtons.animate_scale_up_on_last_button_pressed(), "completed")
    yield($NumButtons.animate_scale_down_on_all_buttons(), "completed")
    yield($NumButtons.animate_shuffle(), "completed")
    $NumButtons.enable_click()
    $Timer.start()

    # emit game signals (score, objective etc.)
    notify_game_changed()


func _on_timer_timeout():
    # set game variables (score, objective etc.)
    reset_game()

    # run animations and reset timer
    $NumButtons.disable_click()
    yield($NumButtons.animate_scale_down_on_all_buttons(), "completed")
    yield($NumButtons.animate_shuffle(), "completed")
    $NumButtons.enable_click()
    $Timer.start()

    # emit game signals (score, objective etc.)
    notify_game_changed()
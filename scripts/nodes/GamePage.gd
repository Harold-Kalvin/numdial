extends Node2D

onready var game = $"/root/Game"


func _ready():
    randomize()
    $NumButtons.init()
    prepare_game()
    game.connect("dial_succeded", self, "_on_dial_succeded")
    game.connect("succeded", self, "_on_succeded")
    game.connect("failed", self, "_on_failed")


func prepare_game():
    set_new_objective()
    game.set_score_for_next_level(10)
    game.reset_score()
    game.reset_level()


func set_new_objective():
    var objective = ""
    for i in _random_digits():
        objective += str(i)
    game.set_objective(objective)


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
    yield($NumButtons.animate_scale_up_on_last_button_pressed(), "completed")
    yield($NumButtons.animate_scale_down_on_all_buttons(), "completed")
    yield($NumButtons.animate_shuffle(), "completed")
    set_new_objective()
    game.increment_score()


func _on_failed():
    yield($NumButtons.animate_scale_up_on_last_button_pressed(), "completed")
    yield($NumButtons.animate_scale_down_on_all_buttons(), "completed")
    yield($NumButtons.animate_shuffle(), "completed")
    set_new_objective()
    game.reset_score()
    game.reset_level()
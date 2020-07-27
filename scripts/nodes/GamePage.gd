extends Node2D

onready var game = $"/root/Game"


func _ready():
    randomize()
    $NumButtons.init()
    set_new_objective()
    game.connect("succeded", self, "_on_succeded")
    game.connect("failed", self, "_on_failed")
    _temp_print_game_state("GAME START")


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


func _on_succeded():
    yield($NumButtons.animate_reset(), "completed")
    yield($NumButtons.animate_shuffle(), "completed")
    set_new_objective()
    game.increment_score()
    _temp_print_game_state("SUCCESS")


func _on_failed():
    yield($NumButtons.animate_reset(), "completed")
    yield($NumButtons.animate_shuffle(), "completed")
    set_new_objective()
    game.reset_score()
    game.reset_level()
    _temp_print_game_state("GAME OVER")


func _temp_print_game_state(title):
    print("\n-------------------------------------------")
    print(title)
    print("objective: ", game.get_objective())
    print("score: ", game.get_score(), "/", game.get_score_for_next_level())
    print("level: ", game.get_level())
    print("-------------------------------------------\n")
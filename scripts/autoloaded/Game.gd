extends Node

signal dial_succeded
signal succeded
signal failed
signal score_changed
signal best_score_changed
signal level_changed
signal objective_changed

var _score = 0
var _best_score = 0
var _current_streak = 0
var _needed_streak = 3
var _level = 1
var _objective = ""
var _dialed_by_player = ""


func get_score():
    return _score


func get_best_score():
    return _best_score


func get_level():
    return _level


func get_objective():
    return _objective


func get_dialed():
    return _dialed_by_player


func increment_score():
    _score += 1
    _current_streak += 1
    if _score > _best_score:
        _best_score = _score
    if _current_streak >= _needed_streak:
        _current_streak = 0
        _increment_level()


func reset_score():
    _score = 0
    _current_streak = 0


func set_needed_streak(new_needed_streak):
    _needed_streak = new_needed_streak


func reset_level():
    _level = 1


func set_objective(new_objective):
    _objective = str(new_objective)
    _dialed_by_player = ""


func emit_score_changed():
    emit_signal("score_changed", _score)


func emit_best_score_changed():
    emit_signal("best_score_changed", _best_score)


func emit_level_changed():
    emit_signal("level_changed", _level)


func emit_objective_changed():
    emit_signal("objective_changed", _objective)


func dial(num):
    _dialed_by_player += str(num)
    var dial_count = _dialed_by_player.length()
    var objective_count = _objective.length()
    
    # notify other scenes
    if _dialed_by_player == _objective.left(dial_count):
        emit_signal("dial_succeded")
        if dial_count == objective_count:
            emit_signal("succeded")
    else:
        emit_signal("failed")


func _increment_level():
    _level += 1
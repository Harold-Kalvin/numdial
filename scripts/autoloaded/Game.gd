extends Node

signal dial_succeded
signal succeded
signal failed
signal score_changed
signal score_for_next_level_changed
signal level_changed
signal objective_changed

var _score = 0
var _score_for_next_level = 10
var _level = 1
var _objective = ""
var _dialed_by_player = ""


func get_score():
    return _score


func get_score_for_next_level():
    return _score_for_next_level


func get_level():
    return _level


func get_objective():
    return _objective


func get_dialed():
    return _dialed_by_player


func increment_score():
    _score += 1
    if _score >= _score_for_next_level:
        _score = 0
        _increment_level()
    emit_signal("score_changed")


func reset_score():
    _score = 0
    emit_signal("score_changed")


func set_score_for_next_level(new_score_for_next_level):
    if _score_for_next_level > 0:
        _score_for_next_level = new_score_for_next_level
        emit_signal("score_for_next_level_changed")


func reset_level():
    _level = 1
    emit_signal("level_changed")


func set_objective(new_objective):
    _objective = str(new_objective)
    _dialed_by_player = ""
    emit_signal("objective_changed")


func dial(num):
    _dialed_by_player += str(num)
    var dial_count = _dialed_by_player.length()
    var objective_count = _objective.length()
    
    # notify other scenes
    if _dialed_by_player == _objective.left(dial_count):
        if dial_count == objective_count:
            emit_signal("succeded")
        else:
            emit_signal("dial_succeded")
    else:
        emit_signal("failed")


func _increment_level():
    _level += 1
    emit_signal("level_changed")
        
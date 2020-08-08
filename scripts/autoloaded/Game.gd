extends Node

signal dial_succeded
signal succeded
signal failed
signal score_changed
signal max_score_changed
signal level_changed
signal objective_changed

var _score = 0
var _max_score = 10
var _level = 1
var _objective = ""
var _dialed_by_player = ""


func get_score():
    return _score


func get_max_score():
    return _max_score


func get_level():
    return _level


func get_objective():
    return _objective


func get_dialed():
    return _dialed_by_player


func increment_score():
    _score += 1
    if _score >= _max_score:
        _score = 0
        _increment_level()
    emit_signal("score_changed", _score)


func reset_score():
    _score = 0
    emit_signal("score_changed", _score)


func set_max_score(new_max_score):
    if _max_score > 0:
        _max_score = new_max_score
        emit_signal("max_score_changed", _max_score)


func reset_level():
    _level = 1
    emit_signal("level_changed", _level)


func set_objective(new_objective):
    _objective = str(new_objective)
    _dialed_by_player = ""
    emit_signal("objective_changed", _objective)


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
    emit_signal("level_changed", _level)
        
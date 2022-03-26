require utils/date
require time
require player_params
require player_skills
require event
require effect
require math


module player public

class Player

    _offset : int = -45
    _player_params : PlayerParams = [[PlayerParams() health=100]]
    _player_skills : PlayerSkills
    _events_happen : array<tuple<int; Date>>
    _active_effects : array<Effect>

    def Player(age_in_days: int)
        Player`set(self, age_in_days)

    def set(age_in_days : int)
        _player_params.age_in_days = age_in_days
        _player_params.age = age_in_days / 365

    def get_age()
        return _player_params.age

    def pass_day()
        _player_params.age_in_days++
        _player_params.age = _player_params.age_in_days / 365

    def add_effect(effect : Effect)
        push(_active_effects, effect)
        
        if effect.is_onetime_effect
            apply_effect(effect)

    def update_active_effects()
        var len = length() <| _active_effects

        for i in range(0,  len)
            if _active_effects[i].starts_at_age <= get_age() && _active_effects[i].is_onetime_effect == false
                var age_delta = _player_params.age_in_days - _active_effects[i].starts_at_age * 365
                if _active_effects[i].timestep == 0 || (age_delta > 0 && age_delta % _active_effects[i].timestep == 0)
                    apply_effect(_active_effects[i])

    def apply_effect(effect : Effect)
        time_jerk = effect.time_jerk_value
        _player_params.health += effect.params.health
        _player_params.intelligence += effect.params.intelligence

    def register_event(event : Event?; date : Date; is_successful : bool)
        var event_happen : tuple<int; Date>
        event_happen._0 = event._id
        event_happen._1 = date

        push_clone(_events_happen, event_happen)
        apply_effect(is_successful ? event._effect : event._effect_on_fail)

    def check_is_event_successful(event : Event?) : bool
        return false
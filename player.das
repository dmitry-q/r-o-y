require daslib/media
require date
require time
require date
require sound_manager
require player_params
require player_skills
require event
require effect
require math
require random
require globals
require constants
require ast

module player public


enum PlayerAttrTable
    PARAMS = 0
    SKILLS = 1


class Player

    _date_of_birth : Date
    _offset : int = -60
    _animation_state : int = 0
    _params : table<int; int>
    _skills : table<int; int>
    _events_happen : array<EventViewData>
    _active_effects : array<Effect>
    _is_dead : bool = false
    _on_player_death: lambda<(): void>

    def Player(age_in_days: int)
        Player`set(self, age_in_days)


    def set(age_in_days : int)
        _offset = 60

        _params <- params_to_set
        
        for x in each_enum(PS ERU)
            _skills[int(x)] = 0

        _params[pk(PK HP)] = 100
        _params[pk(PK MH)] = 100
        _params[pk(PK AID)] = age_in_days
        _params[pk(PK AGE)] = age_in_days / 365


    def act()
        try_react_on_player_death()


    def render()
        let w = get_screen_width()
        let h = get_screen_height()
        fill_circle(w/2 + _offset, 920, 30, 0xCCCC92)
        fill_rect(w/2 - 30 + _offset, 951, 60, 60, 0xD61C4B)

        if _animation_state == 0
            fill_rect(w/2 + 5 + _offset, 1011, 25, 35, 0x114CCA)
            fill_rect(w/2 - 30 + _offset, 1011, 25, 15, 0x1B346E)
        if _animation_state == 1
            fill_rect(w/2 - 30 + _offset, 1011, 25, 35, 0x114CCA)
            fill_rect(w/2 + 5 + _offset, 1011, 25, 15, 0x1B346E)

    
    def animate()
        if _animation_state < 1
            _animation_state++
        else
            _animation_state = 0


    def get_age()
        return _params[pk(PK AGE)]


    def pass_date()
        var prev_age = _params[pk(PK AGE)]
        _params[pk(PK AID)] += date_step
        _params[pk(PK AGE)] = _params[pk(PK AID)] / 365

        if _params[pk(PK AGE)] > prev_age
            update_music(_params[pk(PK AGE)])

        update_active_effects()


    def update_active_effects()
        var len = length() <| _active_effects

        for effect in _active_effects
            if effect.starts_at_age <= get_age() && effect.is_onetime_effect == false

                var age_delta = _params[pk(PK AID)] - effect.starts_at_age * 365
                var started_at_delta = _params[pk(PK AID)] - effect.started_at

                if (effect.started_at == -1 && age_delta > 0 && age_delta % effect.timestep < date_step) || (
                    effect.started_at > -1 && started_at_delta % effect.timestep < date_step)
                    if effect.duration == -1 || started_at_delta <= effect.starts_at_age * 365 + effect.duration
                        apply_effect(effect)


    def add_effect(effect : Effect)
        push_clone(_active_effects, effect)


    def apply_effect(effect : Effect)
        _is_dead = effect.is_game_over
        if effect.time_jerk_value > -1.0
            time_jerk = effect.time_jerk_value

        var ep := effect.params
        for x in each_enum(PK AGE)
            var increment = ep[int(x)]
            _params[int(x)] += increment

        var es := effect.skills
        for x in each_enum(PS ERU)
            var increment = es[int(x)]
            _skills[int(x)] += increment

        _params[pk(PK HP)] = _params[pk(PK HP)] > 100 ? 100 : _params[pk(PK HP)]
        _params[pk(PK HP)] = _params[pk(PK HP)] < 0 ? 0 : _params[pk(PK HP)]
        _params[pk(PK MH)] = _params[pk(PK MH)] > 100 ? 100 : _params[pk(PK MH)]
        _params[pk(PK MH)] = _params[pk(PK MH)] < 0 ? 0 : _params[pk(PK MH)]

        var rand_seed: int4
        randomize_seed(rand_seed)

        if effect.spend_MON_range[0] == -1 && effect.spend_MON_range[1] == -1
            return

        var s_money_delta = effect.spend_MON_range[1] - effect.spend_MON_range[0]
        var max_threshold = clamp(_params[pk(PK INT)] + _skills[ps(PS ENT)], 0, 10)
        var money_to_spend = -1

        while money_to_spend < effect.spend_MON_range[0] || money_to_spend > effect.spend_MON_range[1]
            money_to_spend = random_int(rand_seed)

        money_to_spend = money_to_spend / 10 * (11 - max_threshold)
        _params[pk(PK MON)] -= money_to_spend


    def register_event(event : Event?; date : Date; icon : ImageHandle; log_message : string; is_successful : bool)
        var event_happen : EventViewData
        event_happen.id = event._id
        event_happen.spawned_at = date
        event_happen.icon = icon
        event_happen.log_message = log_message

        push_clone(_events_happen, event_happen)

        var effect_to_apply := is_successful ? event._effect : event._effect_on_fail

        if effect_to_apply.is_onetime_effect
            apply_effect(effect_to_apply)
        else
            effect_to_apply.started_at = _params[pk(PK AID)]

        add_effect(effect_to_apply)


    def validate_event_to_spawn(event : Event?)
        if validate_table(_params, event._required_params_for_spawn, 0) && validate_table(_skills, event._required_skills_for_spawn, 1)
            return true

        return false


    def validate_happen_event(event : Event?)
        if validate_table(_params, event._required_params_for_success, 0) && validate_table(_skills, event._required_skills_for_success, 1)
            return true

        return false


    def validate_required_events(required_events : array<int>) : bool
        var counter = 0
        var len = length(required_events)

        if required_events[0] == 0
            return true

        for required in required_events
            for happen in _events_happen
                if required == happen.id
                    counter++

        if counter == len
            return true

        return false


    def validate_value(value, compare_to : int) : bool

        if sign(compare_to) == 0
            return true

        if sign(compare_to) < 0
            if value >= abs(compare_to)
                return false
        else
            if compare_to > value
                return false

        return true


    def validate_table(tab : table<int; int>; validator : table<int; int>; table_type_index : int) : bool
        var tab_c := tab
        var validator_c := validator
        
        if (table_type_index == 0)

            for x in each_enum(PK AGE)
                var value = tab_c[int(x)]
                var compare_to = validator_c[int(x)]

                if !validate_value(value, compare_to)
                    return false

            return true

        for x in each_enum(PS ERU)
            var value = tab_c[int(x)]
            var compare_to = validator_c[int(x)]

            if !validate_value(value, compare_to)
                return false

        return true


    def try_react_on_player_death()
        if _params[int(PK HP)] <= 0 || _is_dead
            invoke(_on_player_death)

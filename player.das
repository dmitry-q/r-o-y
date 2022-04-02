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

module player public


class Player

    _date_of_birth : Date
    _offset : int = -60
    _animation_state : int = 0
    _params : table<int; int>
    _skills : PlayerSkills
    _events_happen : array<EventViewData>
    _active_effects : array<Effect>
    _is_dead : bool = false
    _on_player_death: lambda<(): void>

    def Player(age_in_days: int)
        Player`set(self, age_in_days)


    def set(age_in_days : int)
        _offset = 60
        _params <- params_to_set
        _params[pk(ParamKey HEALTH)] = 100
        _params[pk(ParamKey MENTAL)] = 100
        _params[pk(ParamKey AGE_IN_DAYS)] = age_in_days
        _params[pk(ParamKey AGE)] = age_in_days / 365


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
        return _params[pk(ParamKey AGE)]


    def pass_date()
        var prev_age = _params[pk(ParamKey AGE)]
        _params[pk(ParamKey AGE_IN_DAYS)] += date_step
        _params[pk(ParamKey AGE)] = _params[pk(ParamKey AGE_IN_DAYS)] / 365

        if _params[pk(ParamKey AGE)] > prev_age
            update_music(_params[pk(ParamKey AGE)])

        update_active_effects()


    def update_active_effects()
        var len = length() <| _active_effects

        for effect in _active_effects
            if effect.starts_at_age <= get_age() && effect.is_onetime_effect == false

                var age_delta = _params[pk(ParamKey AGE_IN_DAYS)] - effect.starts_at_age * 365
                var started_at_delta = _params[pk(ParamKey AGE_IN_DAYS)] - effect.started_at

                if (effect.started_at == -1 && age_delta > 0 && age_delta % effect.timestep < date_step) || (
                    effect.started_at > -1 && started_at_delta % effect.timestep < date_step)
                    apply_effect(effect)


    def add_effect(effect : Effect)
        push_clone(_active_effects, effect)


    def apply_effect(effect : Effect)
        _is_dead = effect.is_game_over
        if effect.time_jerk_value > -1.0
            time_jerk = effect.time_jerk_value

        var ep := effect.params
        for x in each_enum(ParamKey AGE)
            var increment = ep[int(x)]
            _params[int(x)] += increment

        _skills.erudition += effect.skills.erudition
        _skills.empathy += effect.skills.empathy
        _skills.rhetoric += effect.skills.rhetoric
        _skills.enterprise += effect.skills.enterprise
        _skills.survivalist += effect.skills.survivalist
        _skills.art += effect.skills.art
        _skills.math += effect.skills.math
        _skills.native_language += effect.skills.native_language
        _skills.foreign_languages += effect.skills.foreign_languages
        _skills.physics += effect.skills.physics
        _skills.literature += effect.skills.literature
        _skills.technology += effect.skills.technology
        _skills.computer_science += effect.skills.computer_science
        _skills.geography += effect.skills.geography
        _skills.social_studies += effect.skills.social_studies
        _skills.chemistry += effect.skills.chemistry
        _skills.athletics += effect.skills.athletics
        _skills.swimming += effect.skills.swimming
        _skills.driving += effect.skills.driving
        _skills.martial_arts += effect.skills.martial_arts
        _skills.cold_weapons += effect.skills.cold_weapons
        _skills.firearms += effect.skills.firearms

        _params[pk(ParamKey HEALTH)] = _params[pk(ParamKey HEALTH)] > 100 ? 100 : _params[pk(ParamKey HEALTH)]
        _params[pk(ParamKey HEALTH)] = _params[pk(ParamKey HEALTH)] < 0 ? 0 : _params[pk(ParamKey HEALTH)]
        _params[pk(ParamKey MENTAL)] = _params[pk(ParamKey MENTAL)] > 100 ? 100 : _params[pk(ParamKey MENTAL)]
        _params[pk(ParamKey MENTAL)] = _params[pk(ParamKey MENTAL)] < 0 ? 0 : _params[pk(ParamKey MENTAL)]

        var rand_seed: int4
        randomize_seed(rand_seed)

        var s_money_delta = effect.spend_money_range[1]-effect.spend_money_range[0]
        var max_threshold = clamp(_params[pk(ParamKey INTELLIGENCE)] + _skills.enterprise, 0, 10)
        var money_to_spend = -1

        while money_to_spend < effect.spend_money_range[0] || money_to_spend > effect.spend_money_range[1]
            money_to_spend = random_int(rand_seed)

        money_to_spend = money_to_spend / 10 * (10 - max_threshold)
        _params[pk(ParamKey MONEY)] -= money_to_spend


    def register_event(event : Event?; date : Date; icon : ImageHandle; log_message : string; is_successful : bool)
        var event_happen : EventViewData
        event_happen.id = event._id
        event_happen.spawned_at = date
        event_happen.icon = icon
        event_happen.log_message = log_message

        push_clone(_events_happen, event_happen)

        var effect_to_apply := is_successful ? event._effect : event._effect_on_fail
        add_effect(effect_to_apply)

        if effect_to_apply.is_onetime_effect
            apply_effect(effect_to_apply)
        else
            effect_to_apply.started_at = _params[pk(ParamKey AGE_IN_DAYS)]


    def validate_params(event_params : table<int; int>) : bool
        var ep := event_params

        for x in each_enum(ParamKey AGE)
            var value = _params[int(x)]
            var compare_to = ep[int(x)]

            if !validate_value(_params[int(x)], compare_to)
                return false

        return true


    def validate_skills(event_skills : PlayerSkills)
    
        let erudition = _skills.erudition
        let empathy = _skills.empathy
        let rhetoric = _skills.rhetoric
        let enterprise = _skills.enterprise
        let survivalist = _skills.survivalist
        let art = _skills.art
        let music = _skills.music
        let math = _skills.math
        let native_language = _skills.native_language
        let foreign_languages = _skills.foreign_languages
        let literature = _skills.literature
        let technology = _skills.technology
        let computer_science = _skills.computer_science
        let geography = _skills.geography
        let social_studies = _skills.social_studies
        let chemistry = _skills.chemistry
        let athletics = _skills.athletics
        let swimming = _skills.swimming
        let driving = _skills.driving
        let martial_arts = _skills.martial_arts
        let cold_weapons = _skills.cold_weapons
        let firearms = _skills.firearms

        //  s k i l l s
        if  !validate_value(erudition, event_skills.erudition) || (
            !validate_value(empathy, event_skills.empathy)) || (
            !validate_value(rhetoric, event_skills.rhetoric)) || (
            !validate_value(enterprise, event_skills.enterprise)) || (
            !validate_value(survivalist, event_skills.survivalist)) || (
            !validate_value(art, event_skills.art)) || (
            !validate_value(music, event_skills.music)) || (
            !validate_value(math, event_skills.math)) || (
            !validate_value(native_language, event_skills.native_language)) || (
            !validate_value(foreign_languages, event_skills.foreign_languages)) || (
            !validate_value(literature, event_skills.literature)) || (
            !validate_value(technology, event_skills.technology)) || (
            !validate_value(computer_science, event_skills.computer_science)) || (
            !validate_value(geography, event_skills.geography)) || (
            !validate_value(social_studies, event_skills.social_studies)) || (
            !validate_value(chemistry, event_skills.chemistry)) || (
            !validate_value(athletics, event_skills.athletics)) || (
            !validate_value(swimming, event_skills.swimming)) || (
            !validate_value(driving, event_skills.driving)) || (
            !validate_value(martial_arts, event_skills.martial_arts)) || (
            !validate_value(cold_weapons, event_skills.cold_weapons)) || (
            !validate_value(firearms, event_skills.firearms))
            return false

        return true


    def validate_happen_events(required_events : array<int>) : bool
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

    def try_react_on_player_death()
        if _params[int(ParamKey HEALTH)] <= 0 || _is_dead
            invoke(_on_player_death)

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
    _player_params : PlayerParams
    _player_skills : PlayerSkills
    _events_happen : array<EventViewData>
    _active_effects : array<Effect>
    _is_dead : bool = false
    _on_player_death: lambda<(): void>

    def Player(age_in_days: int)
        Player`set(self, age_in_days)


    def set(age_in_days : int)
        _player_params := params_to_set
        _player_params.age_in_days = age_in_days
        _player_params.age = age_in_days / 365

    def get_age()
        return _player_params.age


    def pass_date()
        var prev_age = _player_params.age
        _player_params.age_in_days += date_step
        _player_params.age = _player_params.age_in_days / 365

        if _player_params.age > prev_age
            update_music(_player_params.age)
        
        if _player_params.health <= 0 || _is_dead
            invoke(_on_player_death)

        try_react_on_player_death()
        update_active_effects()


    def update_active_effects()
        var len = length() <| _active_effects

        for effect in _active_effects
            if effect.starts_at_age <= get_age() && effect.is_onetime_effect == false

                var age_delta = _player_params.age_in_days - effect.starts_at_age * 365
                var started_at_delta = _player_params.age_in_days - effect.started_at

                if (effect.started_at == -1 && age_delta > 0 && age_delta % effect.timestep < date_step) || (
                    effect.started_at > -1 && started_at_delta % effect.timestep < date_step)
                    apply_effect(effect)


    def add_effect(effect : Effect)
        push(_active_effects, effect)


    def apply_effect(effect : Effect)
        _is_dead = effect.is_game_over
        if effect.time_jerk_value > -1.0
            time_jerk = effect.time_jerk_value
        _player_params.health += effect.params.health
        _player_params.mental_health += effect.params.mental_health
        _player_params.influence += effect.params.influence
        _player_params.money += effect.params.money

        _player_params.willpower += effect.params.willpower
        _player_params.strength += effect.params.strength
        _player_params.perception += effect.params.perception
        _player_params.endurance += effect.params.endurance
        _player_params.charisma += effect.params.charisma
        _player_params.intelligence += effect.params.intelligence
        _player_params.agility += effect.params.agility
        _player_params.luck += effect.params.luck

        _player_skills.erudition += effect.skills.erudition
        _player_skills.empathy += effect.skills.empathy
        _player_skills.rhetoric += effect.skills.rhetoric
        _player_skills.enterprise += effect.skills.enterprise
        _player_skills.survivalist += effect.skills.survivalist
        _player_skills.art += effect.skills.art
        _player_skills.math += effect.skills.math
        _player_skills.native_language += effect.skills.native_language
        _player_skills.foreign_languages += effect.skills.foreign_languages
        _player_skills.physics += effect.skills.physics
        _player_skills.literature += effect.skills.literature
        _player_skills.technology += effect.skills.technology
        _player_skills.computer_science += effect.skills.computer_science
        _player_skills.geography += effect.skills.geography
        _player_skills.social_studies += effect.skills.social_studies
        _player_skills.chemistry += effect.skills.chemistry
        _player_skills.athletics += effect.skills.athletics
        _player_skills.swimming += effect.skills.swimming
        _player_skills.driving += effect.skills.driving
        _player_skills.martial_arts += effect.skills.martial_arts
        _player_skills.cold_weapons += effect.skills.cold_weapons
        _player_skills.firearms += effect.skills.firearms

        _player_params.health = _player_params.health > 100 ? 100 : _player_params.health
        _player_params.health = _player_params.health < 0 ? 0 : _player_params.health
        _player_params.mental_health = _player_params.mental_health > 100 ? 100 : _player_params.mental_health
        _player_params.mental_health = _player_params.mental_health < 0 ? 0 : _player_params.mental_health

        var rand_seed: int4
        randomize_seed(rand_seed)

        var s_money_delta = effect.spend_money_range[1]-effect.spend_money_range[0]
        var max_threshold = clamp(_player_params.intelligence + _player_skills.enterprise, 0, 10)
        var money_to_spend = -1

        while money_to_spend < effect.spend_money_range[0] || money_to_spend > effect.spend_money_range[1]
            money_to_spend = random_int(rand_seed)

        money_to_spend = money_to_spend / 10 * (10 - max_threshold)
        _player_params.money -= money_to_spend


    def register_event(event : Event?; date : Date; icon : ImageHandle; log_message : string; is_successful : bool)
        var event_happen : EventViewData
        event_happen.id = event._id
        event_happen.spawned_at = date
        event_happen.icon = icon
        event_happen.log_message = log_message

        push_clone(_events_happen, event_happen)

        var effect_to_apply = is_successful ? event._effect : event._effect_on_fail
        add_effect(effect_to_apply)

        if effect_to_apply.is_onetime_effect
            apply_effect(effect_to_apply)
        else
            effect_to_apply.started_at = _player_params.age_in_days


    def validate_player_params(event_params : PlayerParams) : bool

        let age = get_age()
        let health = _player_params.health
        let mental_health = _player_params.mental_health
        let influence = _player_params.influence
        let money = _player_params.money
        let will = _player_params.willpower
        let str = _player_params.strength
        let per = _player_params.perception
        let end = _player_params.endurance
        let charisma = _player_params.charisma
        let intel = _player_params.intelligence
        let agil = _player_params.agility
        let luck = _player_params.luck

        //  p a r a m s
        if  (!validate_value(age, event_params.age)) || (
            !validate_value(health, event_params.health)) || (
            !validate_value(mental_health, event_params.mental_health)) || (
            !validate_value(influence, event_params.influence)) || (
            !validate_value(money, event_params.money)) || (
            !validate_value(will, event_params.willpower)) || (
            !validate_value(str, event_params.strength)) || (
            !validate_value(per, event_params.perception)) || (
            !validate_value(end, event_params.endurance)) || (
            !validate_value(charisma, event_params.charisma)) || (
            !validate_value(intel, event_params.intelligence)) || (
            !validate_value(agil, event_params.agility)) || (
            !validate_value(luck, event_params.luck))
            return false

        return true


    def validate_player_skills(event_skills : PlayerSkills)
    
        let erudition = _player_skills.erudition
        let empathy = _player_skills.empathy
        let rhetoric = _player_skills.rhetoric
        let enterprise = _player_skills.enterprise
        let survivalist = _player_skills.survivalist
        let art = _player_skills.art
        let music = _player_skills.music
        let math = _player_skills.math
        let native_language = _player_skills.native_language
        let foreign_languages = _player_skills.foreign_languages
        let literature = _player_skills.literature
        let technology = _player_skills.technology
        let computer_science = _player_skills.computer_science
        let geography = _player_skills.geography
        let social_studies = _player_skills.social_studies
        let chemistry = _player_skills.chemistry
        let athletics = _player_skills.athletics
        let swimming = _player_skills.swimming
        let driving = _player_skills.driving
        let martial_arts = _player_skills.martial_arts
        let cold_weapons = _player_skills.cold_weapons
        let firearms = _player_skills.firearms

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
        if _player_params.health <= 0 || _is_dead
            invoke(_on_player_death)

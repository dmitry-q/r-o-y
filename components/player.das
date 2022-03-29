require utils/date
require time
require date
require player_params
require player_skills
require event
require effect
require math


module player public


class Player

    _date_of_birth : Date
    _offset : int = -60
    _player_params : PlayerParams = [[PlayerParams() health=100, mental_health=100, willpower=6, charisma=5, luck=4 ]]
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


    def update_active_effects()
        var len = length() <| _active_effects

        for effect in _active_effects
            if effect.starts_at_age <= get_age() && effect.is_onetime_effect == false

                var age_delta = _player_params.age_in_days - effect.starts_at_age * 365
                var started_at_delta = _player_params.age_in_days - effect.started_at

                if (effect.started_at == -1 && age_delta > 0 && age_delta % effect.timestep == 0) || (effect.started_at > -1 && started_at_delta % effect.timestep == 0)
                    apply_effect(effect)


    def add_effect(effect : Effect)
        push(_active_effects, effect)


    def apply_effect(effect : Effect)

        time_jerk = effect.time_jerk_value

        _player_params.health += effect.params.health
        _player_params.mental_health += effect.params.mental_health

        _player_params.willpower += effect.params.willpower
        _player_params.strength += effect.params.strength
        _player_params.perception += effect.params.perception
        _player_params.endurance += effect.params.endurance
        _player_params.charisma += effect.params.charisma
        _player_params.intelligence += effect.params.intelligence
        _player_params.agility += effect.params.agility
        _player_params.luck += effect.params.luck

        _player_params.health = _player_params.health > 100 ? 100 : _player_params.health
        _player_params.health = _player_params.health < 0 ? 0 : _player_params.health
        _player_params.mental_health = _player_params.mental_health > 100 ? 100 : _player_params.mental_health
        _player_params.mental_health = _player_params.mental_health < 0 ? 0 : _player_params.mental_health


    def register_event(event : Event?; date : Date; is_successful : bool)
        var event_happen : tuple<int; Date>
        event_happen._0 = event._id
        event_happen._1 = date

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
        if  !validate_value(age, event_params.age) || (
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
        let design = _player_skills.design
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
            !validate_value(design, event_skills.design)) || (
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
                if required == happen._0
                    counter++

        if counter == len
            return true
        
        return false


    def validate_value(value, compare_to : int) : bool

        if sign(compare_to) == 0
            return true

        if sign(compare_to) > 0
            if compare_to > value
                return false
        else
            if compare_to <= value
                return false

        return true
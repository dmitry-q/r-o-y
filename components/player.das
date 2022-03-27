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
    _offset : int = -45
    _player_params : PlayerParams = [[PlayerParams() health=100, mental_health=100]]
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

        //  p a r a m s
        if  !validate_parameter(age, event._required_params_for_success.age) || (
            !validate_parameter(health, event._required_params_for_success.health)) || (
            !validate_parameter(mental_health, event._required_params_for_success.mental_health)) || (
            !validate_parameter(influence, event._required_params_for_success.influence)) || (
            !validate_parameter(money, event._required_params_for_success.money)) || (
            !validate_parameter(will, event._required_params_for_success.willpower)) || (
            !validate_parameter(str, event._required_params_for_success.strength)) || (
            !validate_parameter(per, event._required_params_for_success.perception)) || (
            !validate_parameter(end, event._required_params_for_success.endurance)) || (
            !validate_parameter(charisma, event._required_params_for_success.charisma)) || (
            !validate_parameter(intel, event._required_params_for_success.intelligence)) || (
            !validate_parameter(agil, event._required_params_for_success.agility)) || (
            !validate_parameter(luck, event._required_params_for_success.luck))
            return false

        //  s k i l l s
        if  !validate_parameter(erudition, event._required_skills_for_success.erudition) || (
            !validate_parameter(empathy, event._required_skills_for_success.empathy)) || (
            !validate_parameter(rhetoric, event._required_skills_for_success.rhetoric)) || (
            !validate_parameter(enterprise, event._required_skills_for_success.enterprise)) || (
            !validate_parameter(survivalist, event._required_skills_for_success.survivalist)) || (
            !validate_parameter(design, event._required_skills_for_success.design)) || (
            !validate_parameter(music, event._required_skills_for_success.music)) || (
            !validate_parameter(math, event._required_skills_for_success.math)) || (
            !validate_parameter(native_language, event._required_skills_for_success.native_language)) || (
            !validate_parameter(foreign_languages, event._required_skills_for_success.foreign_languages)) || (
            !validate_parameter(literature, event._required_skills_for_success.literature)) || (
            !validate_parameter(technology, event._required_skills_for_success.technology)) || (
            !validate_parameter(computer_science, event._required_skills_for_success.computer_science)) || (
            !validate_parameter(geography, event._required_skills_for_success.geography)) || (
            !validate_parameter(social_studies, event._required_skills_for_success.social_studies)) || (
            !validate_parameter(chemistry, event._required_skills_for_success.chemistry)) || (
            !validate_parameter(athletics, event._required_skills_for_success.athletics)) || (
            !validate_parameter(swimming, event._required_skills_for_success.swimming)) || (
            !validate_parameter(driving, event._required_skills_for_success.driving)) || (
            !validate_parameter(martial_arts, event._required_skills_for_success.martial_arts)) || (
            !validate_parameter(cold_weapons, event._required_skills_for_success.cold_weapons)) || (
            !validate_parameter(firearms, event._required_skills_for_success.firearms))
            return false

        return true

    def validate_parameter(parameter, compare_to : int) : bool

        if sign(compare_to) == 0
            return true

        if sign(compare_to) > 0
            if compare_to > parameter
                return false
        else
            if compare_to <= parameter
                return false

        return true
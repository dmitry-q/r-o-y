require player_params
require player_skills
require effect
require utils/date

module event public

enum EventGroup
    COMMON
    SPORT
    CRIMINAL
    STUDY
    PROFESSION

struct EventViewData
    id : int = 0
    spawned_at : Date
    spawn_spot : int = 0


def event_to_view_data(event : Event?; spawned_at : Date; spot : int) : EventViewData
    return [[EventViewData() id=event._id, spawned_at=spawned_at, spawn_spot=spot]]


var test_event = new Event(1, "ЗАКРЫТЫЙ ПЕРЕЛОМ", EventGroup COMMON, 0, 99, 99, 10, 99, false, 0, "Ты сломал руку. Пичалька. На восстановление уйдет пара месяцев. Полежи в постельке и отдохни. Увидимся. Пока-пока.", "Здоровье: -5")

def init_events()
    test_event->initialize_deps_and_effects([{auto 1; 2}], [[PlayerParams() health=0]], [[PlayerParams() health=0]], 
    [[PlayerSkills math=0]], [[PlayerSkills math=0]],[[Effect() is_onetime_effect=true, params=[[PlayerParams() health=-5]]]], [[Effect() is_onetime_effect=true]])

class Event

    _id : int = 0
    _name : string = "event_name"
    _group : EventGroup = EventGroup COMMON

    _min_age: int = 0
    _max_age: int = 99
    _happen_limit : int = 99
    _spawn_limit : int = 99
    _spawn_chance : int = 25

    _required_events_ids : array<int>
    _required_params_for_spawn : PlayerParams
    _required_params_for_success : PlayerParams
    _required_skills_for_spawn : PlayerSkills
    _required_skills_for_success : PlayerSkills

    _effect : Effect
    _effect_on_fail : Effect

    _can_be_paired : bool = false
    _preferred_to_pair_event_id : int = 0

    _description : string = ""
    _effect_description : string = ""


    def Event(
        id : int;
        name : string;
        group : EventGroup;
        min_age: int;
        max_age: int;
        happen_limit : int;
        spawn_limit : int;
        spawn_chance : int;
        can_be_paired : bool;
        preferred_to_pair_event_id : int;
        description : string;
        effect_description : string
    )
        Event`set(
            self, id, name, group, min_age, max_age, happen_limit, spawn_limit, spawn_chance, can_be_paired, preferred_to_pair_event_id,
            description, effect_description
            )

    def set(
        id : int;
        name : string;
        group : EventGroup;
        min_age: int;
        max_age: int;
        happen_limit : int;
        spawn_limit : int;
        spawn_chance : int;
        can_be_paired : bool;
        preferred_to_pair_event_id : int;
        description : string;
        effect_description : string
    )
        _id = id
        _name = name
        _group = group
        _min_age = min_age
        _max_age = max_age
        _happen_limit = happen_limit
        _spawn_limit = spawn_limit
        _spawn_chance = spawn_chance
        _can_be_paired = can_be_paired
        _preferred_to_pair_event_id = preferred_to_pair_event_id
        _description = description
        _effect_description = effect_description

    def initialize_deps_and_effects(
        required_events_ids : array<int>;
        required_params_for_spawn : PlayerParams;
        required_params_for_success : PlayerParams;
        required_skills_for_spawn : PlayerSkills;
        required_skills_for_success : PlayerSkills;
        effect : Effect;
        effect_on_fail : Effect
    )
        _required_events_ids := required_events_ids
        _required_params_for_spawn = required_params_for_spawn
        _required_params_for_success = required_params_for_success
        _required_skills_for_spawn = required_skills_for_spawn
        _required_skills_for_success = required_skills_for_success
        _effect = effect
        _effect_on_fail = effect_on_fail
        return

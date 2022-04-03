require player_params
require player_skills
require date

module effect public

struct Effect

    id : int
    params : table<int; int>
    skills : table<int; int>

    starts_at_age : int = 0
    started_at : int = -1
    duration : int = 0
    timestep : int = 0
    is_onetime_effect : bool = true
    is_game_over : bool = false
    deactivate_effects : int[3]

    spend_MON_range : int[2]
    time_jerk_value : float = -1.0
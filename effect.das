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
    duration : int = -1
    timestep : int = 0
    is_onetime_effect : bool = true
    is_game_over : bool = false
    deactivate_effects : int[3]

    spend_MON_range : int[2] = [[int[2] -1; -1]]
    time_jerk_value : float = -1.0
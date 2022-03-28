require time
require utils/date
require player_params
require player_skills

module effect public

struct Effect

    id : int
    params : PlayerParams
    skills : PlayerSkills

    starts_at_age : int = 0
    duration : int = 0
    timestep : int = 0
    is_onetime_effect : bool = true
    is_game_over : bool = false
    deactivate_effects : int[3]

    time_jerk_value : float = 0.0
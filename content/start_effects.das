require components/effect
require components/player_params

module start_effects public

let DEFAULT_TIME_JERK_EFFECT : Effect <- [[Effect()
    starts_at_age=0,
    timestep=1,
    is_onetime_effect=false,
    time_jerk_value=0.0000145
]];

let DEFAULT_AGING : Effect <- [[Effect()
    starts_at_age=36,
    timestep=365,
    is_onetime_effect=false,
    params = [[PlayerParams() health = -1, intelligence = 0]]
]];

let DEFAULT_DEMENTIA  : Effect <- [[Effect()
    starts_at_age=60,
    timestep=2190,
    is_onetime_effect=false,
    params = [[PlayerParams() health = 0, intelligence = -1]]
]];
module global_effects public

require player_params
require date
require globals
require effect


let DEFAULT_TIME_JERK_EFFECT : Effect <- [[Effect()
    starts_at_age=0,
    timestep=1,
    is_onetime_effect=false,
    time_jerk_value= 0.1864 / 12775.0 * float(date_step)
]];

let DEFAULT_AGING : Effect <- [[Effect()
    starts_at_age=36,
    timestep=365,
    is_onetime_effect=false,
    params <- {{ pk(PK HP)=>-2 }}
]];

let DEFAULT_DEMENTIA : Effect <- [[Effect()
    starts_at_age=60,
    timestep=2190,
    is_onetime_effect=false,
    params <- {{ pk(PK INT)=>-1 }}
]];


let POCKET_MONEY_CHILD : Effect <- [[Effect()
    starts_at_age=7,
    timestep=7,
    duration=365*6,
    is_onetime_effect=false,
    params <- {{ pk(PK MON)=>20 }}
]];


let POCKET_MONEY_TEENAGER : Effect <- [[Effect()
    starts_at_age=13,
    timestep=7,
    duration=365*7,
    is_onetime_effect=false,
    params <- {{ pk(PK MON)=>90 }}
]];


let SPEND_POCKET_MONEY_CHILD : Effect <- [[Effect()
    starts_at_age=7,
    timestep=7,
    duration=365*6,
    is_onetime_effect=false,
    spend_MON_range=[[int[2] 0; 35]]
]];


let SPEND_POCKET_MONEY_TEENAGER : Effect <- [[Effect()
    starts_at_age=13,
    timestep=7,
    duration=365*7,
    is_onetime_effect=false,
    spend_MON_range=[[int[2] 0; 175]]
]];

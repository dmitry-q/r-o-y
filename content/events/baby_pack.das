require components/event
require components/effect
require components/player_params
require components/player_skills

module baby_pack public


    // _id : int
    // _name : string
    // _group : EventGroup
    // _is_instant : bool

    // _min_age: int = 0
    // _max_age: int = 99
    // _happen_limit : int = 99
    // _spawn_limit : int = 99
    // _spawn_chance : int = 25

    // _required_events_ids : array<int>
    // _required_params_for_spawn : PlayerParams
    // _required_params_for_success : PlayerParams
    // _required_skills_for_spawn : PlayerSkills
    // _required_skills_for_success : PlayerSkills

    // _effect : Effect
    // _effect_on_fail : Effect

    // _can_be_paired : bool = false
    // _preferred_to_pair_event_id : int = 0

    // _description : string = ""
    // _effect_description : string = ""

var e_0001 = new Event(1, "СЕРДЕЧНЫЙ ПРИСТУП", EventGroup COMMON, false, 0, -1, 7, 90, 15, false, 0)
var e_0002 = new Event(2, "СМЕРТЕЛЬНЫЙ ЯД", EventGroup COMMON, false, 0, -1, 4, 4, 2, false, 0)
var e_0003 = new Event(3, "ГНЕВ БОГОВ", EventGroup COMMON, false, 0, -1, 4, 4, 1, false, 0)
var e_0004 = new Event(4, "ПОЖАР!", EventGroup COMMON, false, 0, -1, 4, 4, 5, false, 0)

def init_baby_pack()

    e_0001 -> initialize_deps_and_effects( // СЕРДЕЧНЫЙ ПРИСТУП
        [{auto 0}], 
        [[PlayerParams() age=0]], 
        [[PlayerParams() luck=5, health=-30]], 
        [[PlayerSkills math=0]], 
        [[PlayerSkills math=0]],
        [[Effect() is_onetime_effect=true, params=[[PlayerParams() health=-15]]]],
        [[Effect() is_onetime_effect=true, params=[[PlayerParams() health=-999]]]],
        [[EventDescription() 
        on_success="Ваша сердечно-сосудистая система вас подводит. К счастью, скорая помощь поспевает вовремя и спасает вашу жизнь.",
        on_fail="Ваша сердечно-сосудистая система вас подводит и вы погибаете от сердечного приступа. Скорая помощь не успела вас спасти."]],
        [[EventDescription()
        on_success="Здоровье: -15",
        on_fail="Игра окончена"]]
    )
    
    e_0002 -> initialize_deps_and_effects( // СМЕРТЕЛЬНЫЙ ЯД
        [{auto 0}], 
        [[PlayerParams() age=0]], 
        [[PlayerParams() luck=9]], 
        [[PlayerSkills math=0]], 
        [[PlayerSkills math=0]],
        [[Effect() is_onetime_effect=true, params=[[PlayerParams() health=-25]]]],
        [[Effect() is_onetime_effect=true, params=[[PlayerParams() health=-999]]]],
        [[EventDescription() 
        on_success="Всё произошло так быстро, что вы даже не успели осознать, что за смертоносное существо вас ужалило. Ядовитая змея? Может быть паук или ужасный листолаз? К величайшему удивлению всех вокруг, вы чудом сумели выкарабкаться с того света, хоть и не без вреда для здоровья.",
        on_fail="Всё произошло так быстро, что вы даже не успели осознать, что за смертоносное существо вас ужалило. Ядовитая змея? Может быть паук или ужасный листолаз? Впрочем, это уже неважно. Никто не был в силах вас спасти."]],
        [[EventDescription()
        on_success="Здоровье: -25",
        on_fail="Игра окончена"]]
    )
        
    e_0003 -> initialize_deps_and_effects( // ГНЕВ БОГОВ
        [{auto 0}], 
        [[PlayerParams() age=0]], 
        [[PlayerParams() luck=10]], 
        [[PlayerSkills math=0]], 
        [[PlayerSkills math=0]],
        [[Effect() is_onetime_effect=true, params=[[PlayerParams() health=-35]]]],
        [[Effect() is_onetime_effect=true, params=[[PlayerParams() health=-999]]]],
        [[EventDescription() 
        on_success="В вас ударила молния! Шансы выжить при таком событии стремятся к нулю, однако вам это каким-то чудом удалось! Чудовищные ожоги останутся с вами на всю жизнь, но зато мало кто может похвастаться победой в схватке с Перуном или Зевсом. Так что можете собой гордиться!",
        on_fail="Кажется вы чем-то разневали Тора, Перуна или Зевса. Внезапный удар молнии в мгновение обуглил ваше хрупкое тело и история вашей жизни подошла к концу."]],
        [[EventDescription()
        on_success="Здоровье: -35",
        on_fail="Игра окончена"]]
    )

    e_0004 -> initialize_deps_and_effects(
        [{auto 0}], 
        [[PlayerParams() age=0]], 
        [[PlayerParams() luck=4, perception=5]], 
        [[PlayerSkills math=0]], 
        [[PlayerSkills math=0]],
        [[Effect() is_onetime_effect=true, params=[[PlayerParams() money=-3000]]]],
        [[Effect() is_onetime_effect=true, params=[[PlayerParams() health=-999]]]],
        [[EventDescription() 
        on_success="В вашем доме начался пожар. К счастью вам повезло и вы успели почувствовать запах дыма. После чего спешно покинули своё жилище. Пожарные подоспели вовремя, но часть вашего имущество спасти не удалось.",
        on_fail="В вашем доме начался пожар. К сожалению, вам неповезло. Вы не успели вовремя почувствовать запах дыма, а пожарные прибыли слишком поздно, чтобы успеть вас спасти."]],
        [[EventDescription()
        on_success="Деньги: -3000",
        on_fail="Игра окончена"]]
    )


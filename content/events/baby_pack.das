require daslib/media
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

var e_0001 = new Event(1, "СЕРДЕЧНЫЙ ПРИСТУП", EventGroup NO, false, 0, -1, 7, 90, 23, false, 0)
var e_0002 = new Event(2, "СМЕРТЕЛЬНЫЙ ЯД", EventGroup NO, false, 0, -1, 4, 4, 2, false, 0)
var e_0003 = new Event(3, "ГНЕВ БОГОВ", EventGroup NO, false, 0, -1, 4, 4, 2, false, 0)
var e_0004 = new Event(4, "ПОЖАР!", EventGroup NO, false, 0, -1, 4, 8, 5, false, 0)
var e_0005 = new Event(5, "ТИХИЙ РЕБЁНОК", EventGroup NO, false, 0, 0, 1, 1, 0, false, 0)
var e_0006 = new Event(6, "ШУМНЫЙ РЕБЁНОК", EventGroup NO, false, 0, 0, 1, 1, 43, true, 5)
var e_0007 = new Event(7, "ЮНЫЙ ГИМНАСТ", EventGroup NO, false, 0, 0, 1, 1, 20, false, 0)
var e_0008 = new Event(8, "БОЛТУН", EventGroup NO, false, 0, 0, 1, 1, 23, false, 0)
var e_0009 = new Event(9, "ПОТЕРЯ РОДИТЕЛЯ", EventGroup NO, false, 0, 17, 1, 1, 5, false, 0)
var e_0010 = new Event(10, "ПОТЕРЯ РОДИТЕЛЕЙ", EventGroup NO, false, 0, 17, 1, 1, 3, false, 0)
var e_0011 = new Event(11, "СИЛЬНЫЙ ИСПУГ", EventGroup NO, false, 0, 3, 1, 3, 15, false, 0)
var e_0012 = new Event(12, "X-MEN", EventGroup NO, false, 0, 3, 1, 1, 3, false, 0)
var e_0012_1 = new Event(90012, "ПЛОХИЕ ГЕНЫ", EventGroup NO, false, 0, 3, 1, 1, 3, false, 0)
var e_0012_2 = new Event(90012, "ПЛОХИЕ ГЕНЫ", EventGroup NO, false, 0, 3, 1, 1, 2, false, 0)
var e_0013 = new Event(13, "ЭТО ЕЩЁ КТО?", EventGroup NO, false, 0, 3, 1, 5, 21, false, 0)
var e_0014 = new Event(14, "ЦАРЬ ЗВЕРЕЙ", EventGroup NO, false, 0, 3, 1, 6, 15, false, 0)
var e_0015 = new Event(15, "ОБЖОРА", EventGroup NO, false, 0, 7, 1, 55, 25, false, 0)
var e_0016 = new Event(16, "STAY HUNGRY", EventGroup NO, false, 0, 1, 1, 1, 32, false, 0)
var e_0017 = new Event(17, "КУКЛОВОД", EventGroup NO, false, 0, 5, 1, 10, 33, false, 0)
var e_0018 = new Event(18, "GAME OVER", EventGroup NO, true, 0, -1, 1, 1, 0, false, 0)
var e_0019 = new Event(19, "РОСКОМНАДЗОР", EventGroup NO, true, 0, -1, 1, 1, 0, false, 0)
var e_0020 = new Event(20, "ПИЩЕВОЕ ОТРАВЛЕНИЕ", EventGroup NO, false, 0, -1, 100, 250, 15, false, 0)

def init_baby_pack()

    e_0001 -> initialize_deps_and_effects( // СЕРДЕЧНЫЙ ПРИСТУП
        [{auto 0}],
        [[PlayerParams() health=-30]], 
        [[PlayerParams() luck=5]],
        [[PlayerSkills math=0]],
        [[PlayerSkills math=0]],
        [[Effect() is_onetime_effect=true, params=[[PlayerParams() health=-15]]]],
        [[Effect() is_onetime_effect=true, is_game_over=true]],
        [[EventDescription() 
        on_success="Ваша сердечно-сосудистая система вас подводит. К счастью, скорая помощь поспевает вовремя и спасает вашу жизнь.",
        on_fail="Ваша сердечно-сосудистая система вас подводит и вы погибаете от сердечного приступа. Скорая помощь не успела вас спасти."]],
        [[EventDescription()
        on_success="Здоровье: -15",
        on_fail="Здоровье: -100%"]],
        [[EventDescription()
        on_success="Пережили сердечный приступ",
        on_fail="Погибли от сердечного приступа"]],
        create_managed_image("assets/icons/1.png"),
        [{auto 0}],
        [{auto 0}],
        [{auto EventGroup NO}],
        [{auto EventGroup NO}]
    )
    
    e_0002 -> initialize_deps_and_effects( // СМЕРТЕЛЬНЫЙ ЯД
        [{auto 0}], 
        [[PlayerParams() age=0]], 
        [[PlayerParams() luck=9]], 
        [[PlayerSkills math=0]], 
        [[PlayerSkills math=0]],
        [[Effect() is_onetime_effect=true, params=[[PlayerParams() health=-25]]]],
        [[Effect() is_onetime_effect=true, is_game_over=true]],
        [[EventDescription() 
        on_success="Всё произошло так быстро, что вы даже не успели осознать, что за смертоносное существо вас отравило. Ядовитая змея? Может быть паук или ужасный листолаз? К величайшему удивлению всех вокруг, вы чудом сумели выкарабкаться с того света, хоть и не без вреда для здоровья.",
        on_fail="Всё произошло так быстро, что вы даже не успели осознать, что за смертоносное существо вас отравило. Ядовитая змея? Может быть паук или ужасный листолаз? Впрочем, это уже неважно. Никто бы не смог вас спасти."]],
        [[EventDescription()
        on_success="Здоровье: -25",
        on_fail="Здоровье: -100%"]],
        [[EventDescription()
        on_success="Пережили отравление смертельным ядом",
        on_fail="Погибли от смертельного яда"]],
        create_managed_image("assets/icons/2.png"),
        [{auto 0}],
        [{auto 0}],
        [{auto EventGroup NO}],
        [{auto EventGroup NO}]
    )
        
    e_0003 -> initialize_deps_and_effects( // ГНЕВ БОГОВ
        [{auto 0}], 
        [[PlayerParams() age=0]], 
        [[PlayerParams() luck=10]], 
        [[PlayerSkills math=0]], 
        [[PlayerSkills math=0]],
        [[Effect() is_onetime_effect=true, params=[[PlayerParams() health=-35]]]],
        [[Effect() is_onetime_effect=true, is_game_over=true]],
        [[EventDescription() 
        on_success="В вас ударила молния! Шансы выжить при таком событии стремятся к нулю, однако вам это каким-то чудом удалось! Чудовищные ожоги останутся с вами на всю жизнь, но зато мало кто может похвастаться победой в схватке с Перуном или Зевсом. Так что можете собой гордиться!",
        on_fail="Кажется вы чем-то разневали Тора, Перуна или Зевса. Внезапный удар молнии в мгновение обуглил ваше хрупкое тело и история вашей жизни подошла к концу."]],
        [[EventDescription()
        on_success="Здоровье: -35",
        on_fail="Здоровье: -100%"]],
        [[EventDescription()
        on_success="Пережили удар молнии",
        on_fail="Погибли от удара молнии"]],
        create_managed_image("assets/icons/3.png"),
        [{auto 0}],
        [{auto 0}],
        [{auto EventGroup NO}],
        [{auto EventGroup NO}]
    )

    e_0004 -> initialize_deps_and_effects(
        [{auto 0}], 
        [[PlayerParams() age=0]], 
        [[PlayerParams() luck=4, perception=5]], 
        [[PlayerSkills math=0]],
        [[PlayerSkills math=0]],
        [[Effect() is_onetime_effect=true, params=[[PlayerParams() money=-3000]]]],
        [[Effect() is_onetime_effect=true, is_game_over=true]],
        [[EventDescription() 
        on_success="В вашем доме начался пожар. К счастью вам повезло и вы успели почувствовать запах дыма. После чего спешно покинули своё жилище. Пожарные подоспели вовремя, но часть вашего имущество спасти не удалось.",
        on_fail="В вашем доме начался пожар. К сожалению, вам не повезло. Вы не успели вовремя почувствовать запах дыма, а пожарные прибыли слишком поздно, чтобы успеть вас спасти."]],
        [[EventDescription()
        on_success="Деньги: -3000",
        on_fail="Здоровье: -100%"]],
        [[EventDescription()
        on_success="Спаслись от пожара",
        on_fail="Погибли в пожаре"]],
        create_managed_image("assets/icons/4.png"),
        [{auto 0}],
        [{auto 0}],
        [{auto EventGroup NO}],
        [{auto EventGroup NO}]
    )

    e_0005 -> initialize_deps_and_effects(
        [{auto 0}], 
        [[PlayerParams() age=0]], 
        [[PlayerParams() age=0]], 
        [[PlayerSkills math=0]],
        [[PlayerSkills math=0]],
        [[Effect() is_onetime_effect=true]],
        [[Effect() is_onetime_effect=true]],
        [[EventDescription() 
        on_success="Проходят первые дни и недели вашей жизни, и вы проявляете себя, как весьма тихий и спокойный ребёнок. Пока рано делать выводы о вашем будущем характере, но многие психологи утверждают, что темперамент человека - это врождённая черта.",
        on_fail=""]],
        [[EventDescription()
        on_success="Неизвестный эффект",
        on_fail=""]],
        [[EventDescription()
        on_success="Взрослые посчитали вас спокойным ребёнком",
        on_fail=""]],
        create_managed_image("assets/icons/5.png"),
        [{auto 0}],
        [{auto 0}],
        [{auto EventGroup NO}],
        [{auto EventGroup NO}]
    )

    e_0006 -> initialize_deps_and_effects(
        [{auto 0}], 
        [[PlayerParams() age=0]], 
        [[PlayerParams() age=0]], 
        [[PlayerSkills math=0]],
        [[PlayerSkills math=0]],
        [[Effect() is_onetime_effect=true]],
        [[Effect() is_onetime_effect=true]],
        [[EventDescription() 
        on_success="Поздравляю, вы не успели родиться на свет, а уже подпортили нервы всем вокруг. Бесконечный плач и крики по любому поводу, возможно, сигналиризуют о вашем взрывном темпераменте. Но выводы, конечно, пока делать рано.",
        on_fail=""]],
        [[EventDescription()
        on_success="Неизвестный эффект",
        on_fail=""]],
        [[EventDescription()
        on_success="Взрослые посчитали вас шумным ребёнком",
        on_fail=""]],
        create_managed_image("assets/icons/6.png"),
        [{auto 0}],
        [{auto 0}],
        [{auto EventGroup NO}],
        [{auto EventGroup NO}]
    )
    
    e_0007 -> initialize_deps_and_effects(
        [{auto 0}], 
        [[PlayerParams() agility=5]], 
        [[PlayerParams() age=0]], 
        [[PlayerSkills math=0]],
        [[PlayerSkills math=0]],
        [[Effect() is_onetime_effect=true, params=[[PlayerParams() agility=1]]]],
        [[Effect() is_onetime_effect=true]],
        [[EventDescription() 
        on_success="В столь юном возрасте вы уже научились крутить сальто. Не без помощи взрослых, конечно, которые держат вас за руки :) Каждый раз, когда взрослые играют с вами подобным образом - вы приходите в величайший восторг и развиваете вашу гибкость и подвижность.",
        on_fail=""]],
        [[EventDescription()
        on_success="Ловкость: +1, Атлетика: +1",
        on_fail=""]],
        [[EventDescription()
        on_success="С младенчества проявили чудеса гибкости",
        on_fail=""]],
        create_managed_image("assets/icons/7.png"),
        [{auto 0}],
        [{auto 0}],
        [{auto EventGroup NO}],
        [{auto EventGroup NO}]
    )

    e_0008 -> initialize_deps_and_effects(
        [{auto 0}], 
        [[PlayerParams() age=0]], 
        [[PlayerParams() age=0]], 
        [[PlayerSkills math=0]],
        [[PlayerSkills math=0]],
        [[Effect() is_onetime_effect=true, skills=[[PlayerSkills() rhetoric=1]]]],
        [[Effect() is_onetime_effect=true]],
        [[EventDescription() 
        on_success="Подражая взрослым, вы очень рано научились довольно отчётливо произносить отдельные слова и даже целые фразы.",
        on_fail=""]],
        [[EventDescription()
        on_success="Красноречие: +1",
        on_fail=""]],
        [[EventDescription()
        on_success="Рано научились говорить",
        on_fail=""]],
        create_managed_image("assets/icons/8.png"),
        [{auto 0}],
        [{auto 0}],
        [{auto EventGroup NO}],
        [{auto EventGroup NO}]
    )
        
    e_0009 -> initialize_deps_and_effects(
        [{auto 0}], 
        [[PlayerParams() age=0]], 
        [[PlayerParams() health=999]], 
        [[PlayerSkills math=0]],
        [[PlayerSkills math=0]],
        [[Effect() is_onetime_effect=true]],
        [[Effect() is_onetime_effect=true, params=[[PlayerParams() mental_health=-15]]]],
        [[EventDescription() 
        on_success="",
        on_fail="К сожалению один из ваших родителей трагически погибает. Столь ранняя потеря непременно отразится на вашей психике."]],
        [[EventDescription()
        on_success="",
        on_fail="Психическое здоровье: -15"]],
        [[EventDescription()
        on_success="",
        on_fail="Потеряли одного из родителей"]],
        create_managed_image("assets/icons/9.png"),
        [{auto 10}],
        [{auto 0}],
        [{auto EventGroup NO}],
        [{auto EventGroup NO}]
    )

    e_0010 -> initialize_deps_and_effects(
        [{auto 0}], 
        [[PlayerParams() age=0]], 
        [[PlayerParams() health=999]], 
        [[PlayerSkills math=0]],
        [[PlayerSkills math=0]],
        [[Effect() is_onetime_effect=true]],
        [[Effect() is_onetime_effect=true, params=[[PlayerParams() mental_health=-30]]]],
        [[EventDescription() 
        on_success="",
        on_fail="Ваши родители трагически погибают в автокатастрофе. Горе съедает вас, но вы ничего не можете с этим поделать. Только время сможет как-то подлатать вашу душевную рану."]],
        [[EventDescription()
        on_success="",
        on_fail="Психическое здоровье: -30"]],
        [[EventDescription()
        on_success="",
        on_fail="Потеряли обоих родителей"]],
        create_managed_image("assets/icons/10.png"),
        [{auto 9}],
        [{auto 0}],
        [{auto EventGroup NO}],
        [{auto EventGroup NO}]
    )

    e_0011 -> initialize_deps_and_effects(
        [{auto 0}], 
        [[PlayerParams() age=0]], 
        [[PlayerParams() health=999]], 
        [[PlayerSkills math=0]],
        [[PlayerSkills math=0]],
        [[Effect() is_onetime_effect=true]],
        [[Effect() is_onetime_effect=true, params=[[PlayerParams() mental_health=-10, charisma=-1]]]],
        [[EventDescription() 
        on_success="",
        on_fail="Кто-то или что-то вас очень сильно напугало. Это оставит след на вашей психике и сделает вас более замкнутым в будущем. Возможно."]],
        [[EventDescription()
        on_success="",
        on_fail="Психика: -10, Харизма: -1"]],
        [[EventDescription()
        on_success="",
        on_fail="Пережили сильный испуг"]],
        create_managed_image("assets/icons/11.png"),
        [{auto 0}],
        [{auto 0}],
        [{auto EventGroup NO}],
        [{auto EventGroup NO}]
    )
    
    e_0012 -> initialize_deps_and_effects(
        [{auto 0}], 
        [[PlayerParams() luck=9]], 
        [[PlayerParams() age=0]], 
        [[PlayerSkills math=0]],
        [[PlayerSkills math=0]],
        [[Effect() is_onetime_effect=true, params=[[PlayerParams() strength=3]]]],
        [[Effect() is_onetime_effect=true]],
        [[EventDescription() 
        on_success="Вы родились с редкой генетической мутацией, которая потенциально может сделать вас физически-сильнее 95% людей.",
        on_fail=""]],
        [[EventDescription()
        on_success="Сила: +3",
        on_fail=""]],
        [[EventDescription()
        on_success="Узнали, что вы мутант с богатырской силушкой",
        on_fail=""]],
        create_managed_image("assets/icons/12.png"),
        [{auto 0}],
        [{auto 0}],
        [{auto EventGroup NO}],
        [{auto EventGroup NO}]
    )

    e_0012_1 -> initialize_deps_and_effects(
        [{auto 0}], 
        [[PlayerParams() luck=-4]], 
        [[PlayerParams() health=999]], 
        [[PlayerSkills math=0]],
        [[PlayerSkills math=0]],
        [[Effect() is_onetime_effect=true]],
        [[Effect() is_onetime_effect=false, timestep=365, params=[[PlayerParams() mental_health=-2]]]],
        [[EventDescription() 
        on_success="",
        on_fail="Вам не повезло родиться с генетической болезнью, которая непременно отразится на вашем психическом состоянии в будущем."]],
        [[EventDescription()
        on_success="Психика: -2/год",
        on_fail=""]],
        [[EventDescription()
        on_success="",
        on_fail="Узнали о генетической болезни, влияющей на психику"]],
        create_managed_image("assets/icons/12.png"),
        [{auto 0}],
        [{auto 0}],
        [{auto EventGroup NO}],
        [{auto EventGroup NO}]
    )

    e_0012_2 -> initialize_deps_and_effects(
        [{auto 0}], 
        [[PlayerParams() luck=-5]], 
        [[PlayerParams() health=999]], 
        [[PlayerSkills math=0]],
        [[PlayerSkills math=0]],
        [[Effect() is_onetime_effect=true]],
        [[Effect() is_onetime_effect=true, params=[[PlayerParams() health=-35, strength=-2, endurance=-2 ]]]],
        [[EventDescription() 
        on_success="",
        on_fail="Вам крупно не повезло родиться с генетической болезнью, которая сильно снижает ваши физические возможности."]],
        [[EventDescription()
        on_success="",
        on_fail="Здоровье: -35, Сила: -2, Выносливость: -2"]],
        [[EventDescription()
        on_success="",
        on_fail="Узнали о генетической болезни, влияющей на здоровье"]],
        create_managed_image("assets/icons/12.png"),
        [{auto 0}],
        [{auto 0}],
        [{auto EventGroup NO}],
        [{auto EventGroup NO}]
    )

    e_0013 -> initialize_deps_and_effects(
        [{auto 0}], 
        [[PlayerParams() age=0]], 
        [[PlayerParams() health=0]], 
        [[PlayerSkills math=0]],
        [[PlayerSkills math=0]],
        [[Effect() is_onetime_effect=true, skills=[[PlayerSkills() empathy=1]]]],
        [[Effect() is_onetime_effect=true]],
        [[EventDescription() 
        on_success="К вам в гости пришла семейная пара с младенцем. Сначала вы долго изучаете и притираетесь к загадочному человечку, который очень сильно на вас похож, но очень скоро находите с ним общий язык.",
        on_fail=""]],
        [[EventDescription()
        on_success="Эмпатия: +1",
        on_fail=""]],
        [[EventDescription()
        on_success="Знакомитесь со сверстником",
        on_fail=""]],
        create_managed_image("assets/icons/13.png"),
        [{auto 0}],
        [{auto 0}],
        [{auto EventGroup NO}],
        [{auto EventGroup NO}]
    )

    e_0014 -> initialize_deps_and_effects(
        [{auto 0}], 
        [[PlayerParams() age=0]], 
        [[PlayerParams() willpower=6]],
        [[PlayerSkills math=0]],
        [[PlayerSkills math=0]],
        [[Effect() is_onetime_effect=true, params=[[PlayerParams() willpower=1]], skills=[[PlayerSkills() empathy=-1]]]],
        [[Effect() is_onetime_effect=true, params=[[PlayerParams() mental_health=-3]]]],
        [[EventDescription() 
        on_success="Вы вступаете в неравную битву со своим домашним животным. Несмотря на свой юный возраст вы показываете свой характер и выходите из неё победителем. Взрослые объяснили вам, что бить животных - нехорошо. Но вы всё равно ужасно собой гордитесь.",
        on_fail="Вы вступаете в неравную битву со своим домашним животным и терпите сокрушительное поражение. Какое-то время вы будете сторониться этих лохматых чудовищ."]],
        [[EventDescription()
        on_success="Воля: +1, Эмпатия: -1",
        on_fail="Психика: -3"]],
        [[EventDescription()
        on_success="Победили ужасного зверя",
        on_fail="Потерпели поражение от ужасного зверя"]],
        create_managed_image("assets/icons/14.png"),
        [{auto 0}],
        [{auto 0}],
        [{auto EventGroup NO}],
        [{auto EventGroup NO}]
    )

    e_0015 -> initialize_deps_and_effects(
        [{auto 0}], 
        [[PlayerParams() age=0]], 
        [[PlayerParams() health=999]], 
        [[PlayerSkills math=0]],
        [[PlayerSkills math=0]],
        [[Effect() is_onetime_effect=true]],
        [[Effect() is_onetime_effect=false, timestep=730, params=[[PlayerParams() health=-1]]]],
        [[EventDescription() 
        on_success="",
        on_fail="С малых лет вы питаете неподдельную страсть к различной вредной еде. Будьте осторожны! Фастфуд, чипсы и сладкое - не совсем то, что нужно молодому растущему организму."]],
        [[EventDescription()
        on_success="",
        on_fail="Здоровье: -1/2 года"]],
        [[EventDescription()
        on_success="",
        on_fail="Пристрастились к вредной еде"]],
        create_managed_image("assets/icons/15.png"),
        [{auto 0}],
        [{auto 0}],
        [{auto EventGroup NO}],
        [{auto EventGroup NO}]
    )
    

def init_baby_pack_2()
    e_0016 -> initialize_deps_and_effects(
        [{auto 0}], 
        [[PlayerParams() age=0]], 
        [[PlayerParams() health=999]], 
        [[PlayerSkills math=0]],
        [[PlayerSkills math=0]],
        [[Effect() is_onetime_effect=true]],
        [[Effect() is_onetime_effect=true, params=[[PlayerParams() strength=-1]]]],
        [[EventDescription() 
        on_success="",
        on_fail="Как выяснилось, вы тот ещё едок. Возможно вам просто не нравится еда, которой вас кормят?"]],
        [[EventDescription()
        on_success="",
        on_fail="Сила: -1"]],
        [[EventDescription()
        on_success="",
        on_fail="Стали плохо есть"]],
        create_managed_image("assets/icons/16.png"),
        [{auto 0}],
        [{auto 0}],
        [{auto EventGroup NO}],
        [{auto EventGroup NO}]
    )

    // e_0017 -> initialize_deps_and_effects(
    //     [{auto 0}], 
    //     [[PlayerParams() age=0]], 
    //     [[PlayerParams() health=999]], 
    //     [[PlayerSkills math=0]],
    //     [[PlayerSkills math=0]],
    //     [[Effect() is_onetime_effect=true]],
    //     [[Effect() is_onetime_effect=true, params=[[PlayerParams() mental_health=-30]]]],
    //     [[EventDescription() 
    //     on_success="",
    //     on_fail=""]],
    //     [[EventDescription()
    //     on_success="",
    //     on_fail=""]],
    //     [[EventDescription()
    //     on_success="",
    //     on_fail=""]],
    //     create_managed_image("assets/icons/17.png"),
    //     [{auto 0}],
    //     [{auto 0}],
    //     [{auto EventGroup NO}],
    //     [{auto EventGroup NO}]
    // )

    // e_0018 -> initialize_deps_and_effects(
    //     [{auto 0}], 
    //     [[PlayerParams() age=0]], 
    //     [[PlayerParams() health=999]], 
    //     [[PlayerSkills math=0]],
    //     [[PlayerSkills math=0]],
    //     [[Effect() is_onetime_effect=true]],
    //     [[Effect() is_onetime_effect=true, is_game_over=true]],
    //     [[EventDescription() 
    //     on_success="",
    //     on_fail=""]],
    //     [[EventDescription()
    //     on_success="",
    //     on_fail=""]],
    //     create_managed_image("assets/icons/18.png"),
    //     [{auto 0}],
    //     [{auto 0}],
    //     [{auto EventGroup NO}],
    //     [{auto EventGroup NO}]
    // )


    // e_0019 -> initialize_deps_and_effects(
    //     [{auto 0}], 
    //     [[PlayerParams() age=0]], 
    //     [[PlayerParams() health=999]], 
    //     [[PlayerSkills math=0]],
    //     [[PlayerSkills math=0]],
    //     [[Effect() is_onetime_effect=true]],
    //     [[Effect() is_onetime_effect=true, is_game_over=true]],
    //     [[EventDescription() 
    //     on_success="После затяжной депрессии вы не нашли другого выхода, кроме как закончить всё здесь и сейчас.",
    //     on_fail=""]],
    //     [[EventDescription()
    //     on_success="",
    //     on_fail="Здоровье: -100%"]],
    //     create_managed_image("assets/icons/19.png"),
    //     [{auto 0}],
    //     [{auto 0}],
    //     [{auto EventGroup NO}],
    //     [{auto EventGroup NO}]
    // )

    // e_0020 -> initialize_deps_and_effects(
    //     [{auto 0}], 
    //     [[PlayerParams() health=2]], 
    //     [[PlayerParams() health=999]],
    //     [[PlayerSkills math=0]],
    //     [[PlayerSkills math=0]],
    //     [[Effect() is_onetime_effect=true]],
    //     [[Effect() is_onetime_effect=true, params=[[PlayerParams() health=-1]]]],
    //     [[EventDescription() 
    //     on_success="",
    //     on_fail="Упс! Кажется вы съели что-то не то. Вам следует отнестись к выбору продуктов более ответственно."]],
    //     [[EventDescription()
    //     on_success="",
    //     on_fail="Здоровье: -1"]],
    //     create_managed_image("assets/icons/20.png"),
    //     [{auto 0}],
    //     [{auto 0}],
    //     [{auto EventGroup NO}],
    //     [{auto EventGroup NO}]
    // )

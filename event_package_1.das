require daslib/media
require event
require effect
require player_params
require player_skills
require globals

module event_package_1 public


class StartEventPackage
    _events : array<Event?>

    //var e_0018 = new Event(18, "GAME OVER", EventGroup NO, true, 0, -1, 1, 1, 0, false, 0)
    //var e_0019 = new Event(19, "", EventGroup NO, true, 0, -1, 1, 1, 0, false, 0)

    def get_events() : array<Event?>
        return <- _events


    def initialize()
        init_titles()
        init_start_pack()
        init_start_pack_2()


    def init_titles()
        var e_0001 = new Event(1, t("name=1"), EventGroup NO, false, 0, 200, 7, 90, 23, false, 0)
        var e_0002 = new Event(2, "СМЕРТЕЛЬНЫЙ ЯД", EventGroup NO, false, 0, 200, 4, 4, 2, false, 0)
        var e_0003 = new Event(3, "ГНЕВ БОГОВ", EventGroup NO, false, 0, 200, 4, 4, 2, false, 0)
        var e_0004 = new Event(4, "ПОЖАР!", EventGroup NO, false, 0, 200, 18, 18, 7, false, 0)
        var e_0005 = new Event(5, "ТИХИЙ РЕБЁНОК", EventGroup NO, false, 0, 0, 1, 1, 0, false, 0)
        var e_0006 = new Event(6, "ШУМНЫЙ РЕБЁНОК", EventGroup NO, false, 0, 0, 1, 1, 15, true, 5)
        var e_0007 = new Event(7, "ЮНЫЙ ГИМНАСТ", EventGroup NO, false, 0, 0, 1, 1, 20, false, 0)
        var e_0008 = new Event(8, "БОЛТУН", EventGroup NO, false, 0, 0, 1, 1, 23, false, 0)
        var e_0009 = new Event(9, "ПОТЕРЯ РОДИТЕЛЯ", EventGroup NO, false, 0, 17, 1, 18, 5, false, 0)
        var e_0010 = new Event(10, "ПОТЕРЯ РОДИТЕЛЕЙ", EventGroup NO, false, 0, 17, 1, 9, 3, false, 0)
        var e_0011 = new Event(11, "СИЛЬНЫЙ ИСПУГ", EventGroup NO, false, 0, 3, 1, 3, 15, false, 0)
        var e_0012 = new Event(12, "X-MEN", EventGroup NO, false, 0, 3, 1, 1, 3, false, 0)
        var e_0012_1 = new Event(90012, "ПЛОХИЕ ГЕНЫ", EventGroup NO, false, 0, 3, 1, 1, 3, false, 0)
        var e_0012_2 = new Event(90012, "ПЛОХИЕ ГЕНЫ", EventGroup NO, false, 0, 3, 1, 1, 2, false, 0)
        var e_0013 = new Event(13, "ЭТО ЕЩЁ КТО?", EventGroup NO, false, 0, 3, 1, 5, 21, false, 0)
        var e_0014 = new Event(14, "ЦАРЬ ЗВЕРЕЙ", EventGroup NO, false, 0, 3, 1, 6, 15, false, 0)
        var e_0015 = new Event(15, "ЛЮБИТЕЛЬ ФАСТФУДА", EventGroup NO, false, 1, 9, 1, 55, 25, false, 0)
        var e_0016 = new Event(16, "STAY HUNGRY", EventGroup NO, false, 0, 1, 1, 1, 32, false, 0)
        var e_0017 = new Event(17, "КУКЛОВОД", EventGroup NO, false, 0, 5, 3, 15, 15, false, 0)
        var e_0020 = new Event(20, "ОТРАВЛЕНИЕ", EventGroup NO, false, 0, 200, 10, 250, 9, false, 0)

        _events <- [{auto e_0001; e_0002; e_0003; e_0004; e_0005; e_0006; e_0007; e_0008; e_0009; e_0010; e_0011; e_0012; e_0012_1; e_0012_2; e_0013;
                    e_0014; e_0015; e_0016; e_0017; e_0020}]


    def init_start_pack()

        _events[0] -> initialize_deps_and_effects( // СЕРДЕЧНЫЙ ПРИСТУП
            [{auto 15}],
            {{ pk(PK HP)=>-30 }}, 
            {{ pk(PK LUC)=>5 }}, 
            {{ ps(PS MAT)=>0 }}, 
            {{ ps(PS MAT)=>0 }}, 
            [[Effect() is_onetime_effect=true, params<-{{ pk(PK HP)=>-15 }}]],
            [[Effect() is_onetime_effect=true, is_game_over=true]],
            [[EventDescription() 
            on_success= t("desc.s=1"),
            on_fail=t("desc.f=1")]],
            [[EventDescription()
            on_success=t("edesc.s=1"),
            on_fail=t("edesc.f=1")]],
            [[EventDescription()
            on_success=t("log.s=1"),
            on_fail=t("log.f=1")]],
            create_managed_image("assets/icons/1.png"),
            [{auto 0}],
            [{auto 0}],
            [{auto EventGroup NO}],
            [{auto EventGroup NO}]
        )
        
        _events[1] -> initialize_deps_and_effects( // СМЕРТЕЛЬНЫЙ ЯД
            [{auto 0}], 
            {{ pk(PK AGE)=>0 }}, 
            {{ pk(PK LUC)=>9 }}, 
            {{ ps(PS MAT)=>0 }}, 
            {{ ps(PS MAT)=>0 }}, 
            [[Effect() is_onetime_effect=true, params<-{{ pk(PK HP)=>-2 }}]],
            [[Effect() is_onetime_effect=true, is_game_over=true]],
            [[EventDescription() 
            on_success="Всё произошло так быстро, что вы даже не успели осознать, что за смертоносное существо вас отравило. Ядовитая змея? Может быть паук или ужасный листолаз? К величайшему удивлению всех вокруг, вы чудом сумели выкарабкаться с того света, хоть и не без вреда для здоровья.",
            on_fail="Всё произошло так быстро, что вы даже не успели осознать, что за смертоносное существо вас отравило. Ядовитая змея? Может быть паук или ужасный листолаз? Впрочем, это уже неважно. Никто бы не смог вас спасти."]],
            [[EventDescription()
            on_success="Здоровье: -25",
            on_fail="Вы погибли"]],
            [[EventDescription()
            on_success="Пережили отравление смертельным ядом",
            on_fail="Погибли от смертельного яда"]],
            create_managed_image("assets/icons/2.png"),
            [{auto 0}],
            [{auto 0}],
            [{auto EventGroup NO}],
            [{auto EventGroup NO}]
        )
            
        _events[2] -> initialize_deps_and_effects( // ГНЕВ БОГОВ
            [{auto 0}], 
            {{ pk(PK AGE)=>0 }}, 
            {{ pk(PK LUC)=>10 }}, 
            {{ ps(PS MAT)=>0 }}, 
            {{ ps(PS MAT)=>0 }}, 
            [[Effect() is_onetime_effect=true, params<-{{ pk(PK HP)=>-35 }}]],
            [[Effect() is_onetime_effect=true, is_game_over=true]],
            [[EventDescription() 
            on_success="В вас ударила молния! Шансы выжить при таком событии стремятся к нулю, однако вам это каким-то чудом удалось! Чудовищные ожоги останутся с вами на всю жизнь, но зато мало кто может похвастаться победой в схватке с Перуном или Зевсом. Так что можете собой гордиться!",
            on_fail="Кажется вы чем-то разневали Тора, Перуна или Зевса. Внезапный удар молнии в мгновение обуглил ваше хрупкое тело и история вашей жизни подошла к концу."]],
            [[EventDescription()
            on_success="Здоровье: -35",
            on_fail="Вы погибли"]],
            [[EventDescription()
            on_success="Пережили удар молнии",
            on_fail="Погибли от удара молнии"]],
            create_managed_image("assets/icons/3.png"),
            [{auto 0}],
            [{auto 0}],
            [{auto EventGroup NO}],
            [{auto EventGroup NO}]
        )

        _events[3] -> initialize_deps_and_effects(
            [{auto 0}], 
            {{ pk(PK AGE)=>0 }}, 
            {{ pk(PK LUC)=>4; pk(PK PER)=>5 }}, 
            {{ ps(PS MAT)=>0 }}, 
            {{ ps(PS MAT)=>0 }}, 
            [[Effect() is_onetime_effect=true, params<-{{ pk(PK MON)=>-3000 }}]],
            [[Effect() is_onetime_effect=true, is_game_over=true]],
            [[EventDescription() 
            on_success="В вашем доме начался пожар. К счастью вам повезло и вы успели почувствовать запах дыма. После чего спешно покинули своё жилище. Пожарные подоспели вовремя, но часть вашего имущества спасти не удалось.",
            on_fail="В вашем доме начался пожар. К сожалению, вам не повезло. Вы не успели вовремя почувствовать запах дыма, а пожарные прибыли слишком поздно, чтобы успеть вас спасти."]],
            [[EventDescription()
            on_success="Деньги: -3000",
            on_fail="Вы погибли"]],
            [[EventDescription()
            on_success="Спаслись от пожара",
            on_fail="Погибли в пожаре"]],
            create_managed_image("assets/icons/4.png"),
            [{auto 0}],
            [{auto 0}],
            [{auto EventGroup NO}],
            [{auto EventGroup NO}]
        )

        _events[4] -> initialize_deps_and_effects(
            [{auto 0}], 
            {{ pk(PK AGE)=>0 }},
            {{ pk(PK AGE)=>0 }},
            {{ ps(PS MAT)=>0 }}, 
            {{ ps(PS MAT)=>0 }}, 
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

        _events[5] -> initialize_deps_and_effects(
            [{auto 0}], 
            {{ pk(PK AGE)=>0 }},
            {{ pk(PK AGE)=>0 }},
            {{ ps(PS MAT)=>0 }}, 
            {{ ps(PS MAT)=>0 }}, 
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
        
        _events[6] -> initialize_deps_and_effects(
            [{auto 0}], 
            {{ pk(PK AGI)=>5 }},
            {{ pk(PK AGE)=>0 }},
            {{ ps(PS MAT)=>0 }}, 
            {{ ps(PS MAT)=>0 }}, 
            [[Effect() is_onetime_effect=true, params<-{{ pk(PK AGI)=>1 }}]],
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

        _events[7] -> initialize_deps_and_effects(
            [{auto 0}], 
            {{ pk(PK AGE)=>0 }},
            {{ pk(PK AGE)=>0 }},
            {{ ps(PS MAT)=>0 }},
            {{ ps(PS MAT)=>0 }},
            [[Effect() is_onetime_effect=true, skills<-{{ ps(PS RHE)=>1 }}]], 
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
            
        _events[8] -> initialize_deps_and_effects(
            [{auto 0}], 
            {{ pk(PK AGE)=>0 }},
            {{ pk(PK HP)=>999 }},
            {{ ps(PS MAT)=>0 }},
            {{ ps(PS MAT)=>0 }},
            [[Effect() is_onetime_effect=true]],
            [[Effect() is_onetime_effect=true, params<-{{ pk(PK MH)=>-15 }}]],
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

        _events[9] -> initialize_deps_and_effects(
            [{auto 0}], 
            {{ pk(PK AGE)=>0 }},
            {{ pk(PK HP)=>999 }},
            {{ ps(PS MAT)=>0 }},
            {{ ps(PS MAT)=>0 }},
            [[Effect() is_onetime_effect=true]],
            [[Effect() is_onetime_effect=true, params<-{{ pk(PK MH)=>-30 }}]],
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

        _events[10] -> initialize_deps_and_effects(
            [{auto 0}], 
            {{ pk(PK AGE)=>0 }},
            {{ pk(PK HP)=>999 }}, 
            {{ ps(PS MAT)=>0 }},
            {{ ps(PS MAT)=>0 }},
            [[Effect() is_onetime_effect=true]],
            [[Effect() is_onetime_effect=true, params<-{{ pk(PK MH)=>-10; pk(PK CHA)=>-1 }}]],
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
        
        _events[11] -> initialize_deps_and_effects(
            [{auto 0}], 
            {{ pk(PK LUC)=>9 }},
            {{ pk(PK AGE)=>0 }},
            {{ ps(PS MAT)=>0 }},
            {{ ps(PS MAT)=>0 }},
            [[Effect() is_onetime_effect=true, params<-{{ pk(PK STR)=>3 }}]],
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

        _events[12] -> initialize_deps_and_effects(
            [{auto 0}], 
            {{ pk(PK LUC)=>-4 }},
            {{ pk(PK HP)=>999 }}, 
            {{ ps(PS MAT)=>0 }},
            {{ ps(PS MAT)=>0 }},
            [[Effect() is_onetime_effect=true]],
            [[Effect() is_onetime_effect=false, timestep=365, params<-{{ pk(PK MH)=>-2 }}]],
            [[EventDescription() 
            on_success="",
            on_fail="Вам не повезло родиться с генетической болезнью, которая непременно отразится на вашем психическом состоянии в будущем."]],
            [[EventDescription()
            on_success="",
            on_fail="Психика: -2/год"]],
            [[EventDescription()
            on_success="",
            on_fail="Узнали о генетической болезни, влияющей на психику"]],
            create_managed_image("assets/icons/12.png"),
            [{auto 0}],
            [{auto 0}],
            [{auto EventGroup NO}],
            [{auto EventGroup NO}]
        )

        _events[13] -> initialize_deps_and_effects(
            [{auto 0}], 
            {{ pk(PK LUC)=>-5 }}, 
            {{ pk(PK HP)=>999 }}, 
            {{ ps(PS MAT)=>0 }},
            {{ ps(PS MAT)=>0 }},
            [[Effect() is_onetime_effect=true]],
            [[Effect() is_onetime_effect=true, params<-{{ pk(PK HP)=>-35; pk(PK STR)=>-2; pk(PK END)=>-2 }}]],
            [[EventDescription() 
            on_success="",
            on_fail="Вам крупно не повезло родиться с генетической болезнью, которая сильно снижает ваши физические возможности."]],
            [[EventDescription()
            on_success="",
            on_fail="Здоровье: -35, Сила: -2, Выносливость: -2"]],
            [[EventDescription()
            on_success="",
            on_fail="Узнали о генетической болезни, ухудшающей здоровье"]],
            create_managed_image("assets/icons/12.png"),
            [{auto 0}],
            [{auto 0}],
            [{auto EventGroup NO}],
            [{auto EventGroup NO}]
        )

        _events[14] -> initialize_deps_and_effects(
            [{auto 0}], 
            {{ pk(PK AGE)=>0 }},
            {{ pk(PK AGE)=>0 }}, 
            {{ ps(PS MAT)=>0 }},
            {{ ps(PS MAT)=>0 }},
            [[Effect() is_onetime_effect=true, skills<-{{ ps(PS EMP)=>1 }}]],
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

        _events[15] -> initialize_deps_and_effects(
            [{auto 0}], 
            {{ pk(PK AGE)=>0 }},
            {{ pk(PK WIL)=>5 }},
            {{ ps(PS MAT)=>0 }},
            {{ ps(PS MAT)=>0 }},
            [[Effect() is_onetime_effect=true, params<-{{ pk(PK WIL)=>1 }}, skills<-{{ ps(PS EMP)=>-1 }}]],
            [[Effect() is_onetime_effect=true, params<-{{ pk(PK MH)=>-3 }}]],
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
        

    def init_start_pack_2()

        _events[16] -> initialize_deps_and_effects(
            [{auto 0}], 
            {{ pk(PK AGE)=>0 }}, 
            {{ pk(PK HP)=>999 }}, 
            {{ ps(PS MAT)=>0 }},
            {{ ps(PS MAT)=>0 }},
            [[Effect() is_onetime_effect=true]],
            [[Effect() is_onetime_effect=false, timestep=730, params<-{{ pk(PK HP)=>-1 }}]],
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

        _events[17] -> initialize_deps_and_effects(
            [{auto 0}], 
            {{ pk(PK AGE)=>0 }},  
            {{ pk(PK AGE)=>0 }}, 
            {{ ps(PS MAT)=>0 }},
            {{ ps(PS MAT)=>0 }},
            [[Effect() is_onetime_effect=true, params<-{{ pk(PK STR)=>-1; pk(PK INT)=>1 }}]],
            [[Effect() is_onetime_effect=true]],
            [[EventDescription() 
            on_success="Как выяснилось, вы тот ещё едок. Возможно вам просто не нравится еда, которой вас кормят? Силачом вам с таким аппетитом явно не стать, зато лёгкий голод отлично стимулирует умственные способности!",
            on_fail=""]],
            [[EventDescription()
            on_success="Интеллект: +1, Сила: -1",
            on_fail=""]],
            [[EventDescription()
            on_success="Стали плохо есть",
            on_fail=""]],
            create_managed_image("assets/icons/16.png"),
            [{auto 0}],
            [{auto 0}],
            [{auto EventGroup NO}],
            [{auto EventGroup NO}]
        )

        _events[18] -> initialize_deps_and_effects(
            [{auto 0}], 
            {{ pk(PK AGE)=>0 }}, 
            {{ pk(PK AGE)=>0 }}, 
            {{ ps(PS MAT)=>0 }},
            {{ ps(PS MAT)=>0 }},
            [[Effect() is_onetime_effect=true, skills<-{{ ps(PS ART)=>1 }}]],
            [[Effect() is_onetime_effect=true]],
            [[EventDescription() 
            on_success="Вас не оттащить от игрушек! Причём вы играете с ними настолько изобретательно и масштабно, что любой театральный режиссёр бы позавидовал.",
            on_fail=""]],
            [[EventDescription()
            on_success="Творчество: +1",
            on_fail=""]],
            [[EventDescription()
            on_success="Обнаружили, что обожаете играть с игрушками",
            on_fail=""]],
            create_managed_image("assets/icons/17.png"),
            [{auto 0}],
            [{auto 0}],
            [{auto EventGroup NO}],
            [{auto EventGroup NO}]
        )

        _events[19] -> initialize_deps_and_effects(
            [{auto 0}], 
            {{ pk(PK AGE)=>0 }}, 
            {{ pk(PK HP)=>-2 }},
            {{ ps(PS MAT)=>0 }},
            {{ ps(PS MAT)=>0 }},
            [[Effect() is_onetime_effect=true]],
            [[Effect() is_onetime_effect=true, params<-{{ pk(PK HP)=>-1 }}]],
            [[EventDescription() 
            on_success="Упс! Кажется вы съели что-то не то и отравились. Но учитывая состояние вашего здоровья, вас это сейчас волнует меньше всего.",
            on_fail="Упс! Кажется вы съели что-то не то. Вам следует отнестись к выбору продуктов более ответственно."]],
            [[EventDescription()
            on_success="Нет эффекта",
            on_fail="Здоровье: -1"]],
            [[EventDescription()
            on_success="Чем-то отравились",
            on_fail="Чем-то отравились"]],
            create_managed_image("assets/icons/20.png"),
            [{auto 0}],
            [{auto 0}],
            [{auto EventGroup NO}],
            [{auto EventGroup NO}]
        )

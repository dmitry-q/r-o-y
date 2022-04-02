require daslib/media
require event
require effect
require player_params
require player_skills

module event_package_2 public


class ExtEventPackage1
    _events : array<Event?>


    def get_events() : array<Event?>
        return <- _events


    def initialize()
        init_titles()
        init_pack()


    def init_titles()
        var e_0023 = new Event(23, "ХВОРЬ", EventGroup NO, false, 1, 200, 20, 45, 8, false, 0)
        var e_0024 = new Event(24, "ТОРГИ ИСКУССТВОМ", EventGroup NO, false, 4, 6, 10, 20, 7, false, 0)
        var e_0025 = new Event(25, "МЕЛКИЙ ЗАДИРА", EventGroup NO, false, 4, 6, 9, 25, 15, false, 0)
        var e_0026 = new Event(26, "КАК РЫБА В ВОДЕ", EventGroup NO, false, 0, 200, 1, 100, 9, false, 0)
        var e_0027 = new Event(27, "УКРАДЕННЫЙ МОРЕМ", EventGroup NO, false, 0, 200, 1, 50, 5, false, 0)
        var e_0028 = new Event(28, "ВЫПРОСИЛ ВСЁ-ТАКИ!", EventGroup NO, false, 4, 11, 5, 60, 10, false, 0)
        var e_0029 = new Event(29, "НУ АРТИСТ!", EventGroup NO, false, 4, 6, 1, 5, 5, false, 0)
        var e_0030 = new Event(30, "КНИЖНЫЙ ЧЕРВЬ", EventGroup NO, false, 5, 200, 500, 100, 7, false, 0)
        var e_0031 = new Event(31, "САМОСТОЯТЕЛЬНЫЙ", EventGroup NO, false, 4, 6, 1, 4, 8, false, 0)
        var e_0032 = new Event(32, "ПОЧТИ ТАРЗАН", EventGroup NO, false, 4, 12, 1, 5, 5, false, 0)
        var e_0033 = new Event(33, "ДРУЗЬЯ-СОСЕДИ", EventGroup NO, false, 4, 12, 5, 13, 12, false, 0)
        var e_0050 = new Event(50, "БОЕЦ", EventGroup SPORT, false, 7, 19, 1, 6, 6, false, 0)
        
        // var e_0012 = new Event(12, "X-MEN", EventGroup NO, false, 0, 3, 1, 1, 3, false, 0)
        // var e_0012_1 = new Event(90012, "ПЛОХИЕ ГЕНЫ", EventGroup NO, false, 0, 3, 1, 1, 3, false, 0)
        // var e_0012_2 = new Event(90012, "ПЛОХИЕ ГЕНЫ", EventGroup NO, false, 0, 3, 1, 1, 2, false, 0)
        // var e_0013 = new Event(13, "ЭТО ЕЩЁ КТО?", EventGroup NO, false, 0, 3, 1, 5, 21, false, 0)
        // var e_0014 = new Event(14, "ЦАРЬ ЗВЕРЕЙ", EventGroup NO, false, 0, 3, 1, 6, 15, false, 0)
        // var e_0015 = new Event(15, "ЛЮБИТЕЛЬ ФАСТФУДА", EventGroup NO, false, 0, 7, 1, 55, 25, false, 0)
        // var e_0016 = new Event(16, "STAY HUNGRY", EventGroup NO, false, 0, 1, 1, 1, 32, false, 0)
        // var e_0017 = new Event(17, "КУКЛОВОД", EventGroup NO, false, 0, 5, 3, 15, 15, false, 0)
        // var e_0020 = new Event(20, "ОТРАВЛЕНИЕ", EventGroup NO, false, 0, 200, 10, 250, 9, false, 0)

        _events <- [{auto e_0023; e_0024; e_0025; e_0026; e_0027; e_0028; e_0029; e_0030; e_0031; e_0032; e_0033; e_0050}]


    def init_pack()
      
        _events[0] -> initialize_deps_and_effects(
            [{auto 0}], 
            {{ pk(ParamKey AGE)=>1 }},
            {{ pk(ParamKey HEALTH)=>999 }},
            [[PlayerSkills math=0]],
            [[PlayerSkills math=0]],
            [[Effect() is_onetime_effect=true]],
            [[Effect() is_onetime_effect=true, params<-{{ pk(ParamKey HEALTH)=>-10 }}]],
            [[EventDescription()
            on_success="",
            on_fail="Тяжёлая болезнь приковывает вас к постели на пару недель. Будем надеяться, что вы поправитесь."]],
            [[EventDescription()
            on_success="",
            on_fail="Здоровье: -10"]],
            [[EventDescription()
            on_success="",
            on_fail="Перенесли тяжёлую болезнь"]],
            create_managed_image("assets/icons/23.png"),
            [{auto 0}],
            [{auto 0}],
            [{auto EventGroup NO}],
            [{auto EventGroup NO}]
        )

        _events[1] -> initialize_deps_and_effects(
            [{auto 0}], 
            {{ pk(ParamKey INTELLIGENCE)=>3; pk(ParamKey CHARISMA)=>5 }},
            {{ pk(ParamKey AGE)=>0 }}, 
            [[PlayerSkills math=0]],
            [[PlayerSkills math=0]],
            [[Effect() is_onetime_effect=true, skills=[[PlayerSkills() enterprise=1, art=1]]]],
            [[Effect() is_onetime_effect=true]],
            [[EventDescription() 
            on_success="Юным художникам тоже нужно на что-то жить. На что-то покупать колу, жвачки и мороженое. Поэтому вы решаете продать родственнику свою, скажем так, картину. А ему, в свою очередь, неудобно отказывать ребёнку.",
            on_fail=""]],
            [[EventDescription()
            on_success="Предприимчивость: +1, Творчество: +1",
            on_fail=""]],
            [[EventDescription()
            on_success="Продали картину родственнику",
            on_fail=""]],
            create_managed_image("assets/icons/24.png"),
            [{auto 0}],
            [{auto 0}],
            [{auto EventGroup NO}],
            [{auto EventGroup NO}]
        )

      
        _events[2] -> initialize_deps_and_effects(
            [{auto 0}], 
            {{ pk(ParamKey AGE)=>4 }},
            {{ pk(ParamKey STRENGHT)=>5 }},
            [[PlayerSkills math=0]],
            [[PlayerSkills math=0]],
            [[Effect() is_onetime_effect=true, skills=[[PlayerSkills() martial_arts=1]], params<-{{ pk(ParamKey INFLUENCE)=>1 }}]],
            [[Effect() is_onetime_effect=true, params<-{{ pk(ParamKey HEALTH)=>-1; pk(ParamKey MENTAL)=>-1 }}]],
            [[EventDescription() 
            on_success="Приходя домой со ссадинами и синяками, вы объясняете родителям, что тот ребёнок первый начал. Однако, между делом отмечаете, что выглядит он сейчас гораздо хуже.",
            on_fail="Вас побил другой ребёнок, пока вы гуляли на улице. Кто начал первым - спорный вопрос, но все вокруг вам постоянно говорят, что драться - плохо. Может быть стоит прислушаться?"]],
            [[EventDescription()
            on_success="Боевые искусства: +1, Влияние: +1",
            on_fail="Здоровье: -1, Психика: -1"]],
            [[EventDescription()
            on_success="Победили в дворовой драке",
            on_fail="Потерпели поражение в дворовой драке"]],
            create_managed_image("assets/icons/25.png"),
            [{auto 0}],
            [{auto 0}],
            [{auto EventGroup NO}],
            [{auto EventGroup NO}]
        )

  
        _events[3] -> initialize_deps_and_effects(
            [{auto 0}], 
            {{ pk(ParamKey AGE)=>4 }},
            {{ pk(ParamKey HEALTH)=>0 }}, 
            [[PlayerSkills math=0]],
            [[PlayerSkills math=0]],
            [[Effect() is_onetime_effect=true, skills=[[PlayerSkills() athletics=1, swimming=1]]]],
            [[Effect() is_onetime_effect=true]],
            [[EventDescription()
            on_success="Человек - не рыба, и не должен уметь плавать. Но после нескольких занятий в бассейне вы теперь умеете. Поздравляю!",
            on_fail=""]],
            [[EventDescription()
            on_success="Атлетика: +1, Научились плавать",
            on_fail=""]],
            [[EventDescription()
            on_success="Научились плавать",
            on_fail=""]],
            create_managed_image("assets/icons/26.png"),
            [{auto 0}],
            [{auto 0}],
            [{auto EventGroup NO}],
            [{auto EventGroup NO}]
        )

        _events[4] -> initialize_deps_and_effects(
            [{auto 0}], 
            {{ pk(ParamKey AGE)=>4 }},
            {{ pk(ParamKey HEALTH)=>999 }},
            [[PlayerSkills swimming=-1]],
            [[PlayerSkills math=0]],
            [[Effect() is_onetime_effect=true]],
            [[Effect() is_onetime_effect=true, is_game_over=true]],
            [[EventDescription()
            on_success="",
            on_fail="Совершенно случайно вы оказались на море. И утонули. Потому как не умели плавать. Что тут ещё сказать?"]],
            [[EventDescription()
            on_success="",
            on_fail="Вы погибли"]],
            [[EventDescription()
            on_success="",
            on_fail="Утонули"]],
            create_managed_image("assets/icons/27.png"),
            [{auto 0}],
            [{auto 0}],
            [{auto EventGroup NO}],
            [{auto EventGroup NO}]
        )


        _events[5] -> initialize_deps_and_effects(
            [{auto 0}], 
            {{ pk(ParamKey AGE)=>4 }},
            {{ pk(ParamKey HEALTH)=>0 }},
            [[PlayerSkills rhetoric=1]],
            [[PlayerSkills math=0]],
            [[Effect() is_onetime_effect=true, skills=[[PlayerSkills() rhetoric=1]]]],
            [[Effect() is_onetime_effect=true]],
            [[EventDescription()
            on_success="Проявив чудеса дипломатии, а так же парочку психологических манипуляций, неосознанно конечно, вы наконец-то заполучили в свои цепкие лапы игрушку, которую так давно вожделели.",
            on_fail=""]],
            [[EventDescription()
            on_success="Красноречие: +1",
            on_fail=""]],
            [[EventDescription()
            on_success="Выпросили у родителей долгожданную игрушку",
            on_fail=""]],
            create_managed_image("assets/icons/28.png"),
            [{auto 0}],
            [{auto 0}],
            [{auto EventGroup NO}],
            [{auto EventGroup NO}]
        )


        _events[6] -> initialize_deps_and_effects(
            [{auto 0}], 
            {{ pk(ParamKey CHARISMA)=>4 }},
            {{ pk(ParamKey HEALTH)=>0 }}, 
            [[PlayerSkills art=1]],
            [[PlayerSkills math=0]],
            [[Effect() is_onetime_effect=true, skills=[[PlayerSkills() art=1, rhetoric=1]]]],
            [[Effect() is_onetime_effect=true]],
            [[EventDescription()
            on_success="Вы сыграли в детском спектакле и вам жутко нравится красоваться на сцене. Вы почти не боитесь публики, а по оценкам психиатров, страх перед выступлением испытывают около 95 % людей.",
            on_fail=""]],
            [[EventDescription()
            on_success="Красноречие: +1, Творчество: +1",
            on_fail=""]],
            [[EventDescription()
            on_success="Сыграли в детском спектакле",
            on_fail=""]],
            create_managed_image("assets/icons/29.png"),
            [{auto 0}],
            [{auto 0}],
            [{auto EventGroup NO}],
            [{auto EventGroup NO}]
        )

        _events[7] -> initialize_deps_and_effects(
            [{auto 0}], 
            {{ pk(ParamKey INTELLIGENCE)=>2 }},
            {{ pk(ParamKey HEALTH)=>0 }}, 
            [[PlayerSkills math=0]],
            [[PlayerSkills math=0]],
            [[Effect() is_onetime_effect=true, skills=[[PlayerSkills() erudition=1]]]],
            [[Effect() is_onetime_effect=true]],
            [[EventDescription()
            on_success="Вы только что прочли дико интересную, но столь же дико бесполезную книгу. Пара интересных мыслей несомненно отложится у вас в голове, но на этом всё.",
            on_fail=""]],
            [[EventDescription()
            on_success="Эрудиция: +1",
            on_fail=""]],
            [[EventDescription()
            on_success="Прочли интереснейшую книгу",
            on_fail=""]],
            create_managed_image("assets/icons/30.png"),
            [{auto 0}],
            [{auto 0}],
            [{auto EventGroup NO}],
            [{auto EventGroup NO}]
        )

        _events[8] -> initialize_deps_and_effects(
            [{auto 0}], 
            {{ pk(ParamKey AGILITY)=>2 }},
            {{ pk(ParamKey HEALTH)=>0 }}, 
            [[PlayerSkills math=0]],
            [[PlayerSkills math=0]],
            [[Effect() is_onetime_effect=true, params<-{{ pk(ParamKey AGILITY)=>1 }}]],
            [[Effect() is_onetime_effect=true]],
            [[EventDescription()
            on_success="Вы знали, что есть люди, которые будучи взрослыми не умеют завязывать шнурки? У всех свои причуды. Но вы теперь умеете, вы молодец.",
            on_fail=""]],
            [[EventDescription()
            on_success="Ловкость: +1",
            on_fail=""]],
            [[EventDescription()
            on_success="Научились завязывать шнурки",
            on_fail=""]],
            create_managed_image("assets/icons/31.png"),
            [{auto 0}],
            [{auto 0}],
            [{auto EventGroup NO}],
            [{auto EventGroup NO}]
        )


        _events[9] -> initialize_deps_and_effects(
            [{auto 0}], 
            {{ pk(ParamKey AGILITY)=>4 }},
            {{ pk(ParamKey HEALTH)=>0 }}, 
            [[PlayerSkills math=0]],
            [[PlayerSkills math=0]],
            [[Effect() is_onetime_effect=true, params<-{{ pk(ParamKey AGILITY)=>1 }}]],
            [[Effect() is_onetime_effect=true]],
            [[EventDescription()
            on_success="Вы научились очень ловко лазить по деревьям. Своеобразный навык. Но поживём-увидим, к чему он вас в дальнейшем приведёт.",
            on_fail=""]],
            [[EventDescription()
            on_success="Ловкость: +1",
            on_fail=""]],
            [[EventDescription()
            on_success="Научились лазить по деревьям",
            on_fail=""]],
            create_managed_image("assets/icons/32.png"),
            [{auto 0}],
            [{auto 0}],
            [{auto EventGroup NO}],
            [{auto EventGroup NO}]
        )


        _events[10] -> initialize_deps_and_effects(
            [{auto 0}], 
            {{ pk(ParamKey CHARISMA)=>4 }}, 
            {{ pk(ParamKey HEALTH)=>0 }}, 
            [[PlayerSkills math=0]],
            [[PlayerSkills math=0]],
            [[Effect() is_onetime_effect=true, params<-{{ pk(ParamKey INFLUENCE)=>1 }}, skills=[[PlayerSkills() empathy=1]]]],
            [[Effect() is_onetime_effect=true]],
            [[EventDescription()
            on_success="Вы часто гуляете в окрестностях своего жилища. И вот в ходе очередной такой прогулки вы знакомитесь с одним из ваших будущих хороших друзей.",
            on_fail=""]],
            [[EventDescription()
            on_success="Влияние: +1, Эмпатия: +1",
            on_fail=""]],
            [[EventDescription()
            on_success="Подружились с соседом",
            on_fail=""]],
            create_managed_image("assets/icons/33.png"),
            [{auto 0}],
            [{auto 0}],
            [{auto EventGroup NO}],
            [{auto EventGroup NO}]
        )

        
        _events[11] -> initialize_deps_and_effects(
            [{auto 0}],
            {{ pk(ParamKey STRENGHT)=>2; pk(ParamKey ENDURANCE)=>4 }}, 
            {{ pk(ParamKey HEALTH)=>0 }}, 
            [[PlayerSkills math=0]],
            [[PlayerSkills math=0]],
            [[Effect() is_onetime_effect=false, timestep=365, skills=[[PlayerSkills() martial_arts=1]]]],
            [[Effect() is_onetime_effect=true]],
            [[EventDescription() 
            on_success="Дух воина в вас пробудился, и вы решили всерьёз заняться боевыми искусствами, чтобы суметь защитить себя в критической ситуации.",
            on_fail=""]],
            [[EventDescription()
            on_success="Боевые искусства: +1/год",
            on_fail=""]],
            [[EventDescription()
            on_success="Заинтересовались единоборствами",
            on_fail=""]],
            create_managed_image("assets/icons/50.png"),
            [{auto 0}],
            [{auto 0}],
            [{auto EventGroup NO}],
            [{auto EventGroup NO}]
        )
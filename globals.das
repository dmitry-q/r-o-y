require player_params

module globals public

enum Language
    RU = 0
    EN = 1

var set_current_scene : lambda<(name : string) : void>
var params_to_set : table<int; int> <- {{   pk(PK WIL)=>4;
                                            pk(PK STR)=>4;
                                            pk(PK PER)=>4;
                                            pk(PK END)=>4;
                                            pk(PK CHA)=>4;
                                            pk(PK INT)=>4;
                                            pk(PK AGI)=>4;
                                            pk(PK LUC)=>4
                                        }}
var lang : Language
var date_step : int = 7


var dict_RU : table<string; string>
var dict_EN : table<string; string>


def t(str : string) : string
    if lang == Language RU
        return dict_RU[(str)]
    return dict_EN[(str)]


def initialize_locales_RU() : table<string; string>

    dict_RU["mode"] = "ВЫБЕРИТЕ РЕЖИМ"

    dict_RU["params.title"] = "РАСПРЕДЕЛИТЕ ПАРАМЕТРЫ"
    dict_RU["params.available"] = "ДОСТУПНО"
    dict_RU["params.start"] = "НАЧАТЬ"

    dict_RU["params.will"] = "ВОЛЯ"
    dict_RU["params.str"] = "СИЛА"
    dict_RU["params.per"] = "ВОСПРИЯТИЕ"
    dict_RU["params.end"] = "ВЫНОСЛИВОСТЬ"
    dict_RU["params.cha"] = "ХАРИЗМА"
    dict_RU["params.int"] = "ИНТЕЛЛЕКТ"
    dict_RU["params.agi"] = "ЛОВКОСТЬ"
    dict_RU["params.LUC"] = "УДАЧА"

    dict_RU["today"] = "Сегодня"
    dict_RU["next"] = "ДАЛЕЕ"
    dict_RU["gameover"] = "КОНЕЦ ИГРЫ"
    dict_RU["quit"] = "В ГЛАВНОЕ МЕНЮ"

    dict_RU["hp"] = "Здоровье: "
    dict_RU["pp"] = "Психика:  "
    dict_RU["age"] = "Возраст:  "
    dict_RU["MON"] = "Деньги:   "
    dict_RU["infl"] = "Влияние:  "

    dict_RU["will"] = "Воля:          "
    dict_RU["str"] = "Сила:          "
    dict_RU["per"] = "Восприятие:    "
    dict_RU["end"] = "Выносливость:  "
    dict_RU["cha"] = "Харизма:       "
    dict_RU["int"] = "Интеллект:     "
    dict_RU["agi"] = "Ловкость:      "
    dict_RU["LUC"] = "Удача:         "

    dict_RU["s.eru"] = "Эрудиция:            "
    dict_RU["s.emp"] = "Эмпатия:             "
    dict_RU["s.rhe"] = "Красноречие:         "
    dict_RU["s.ent"] = "Предприимчивость:    "
    dict_RU["s.sur"] = "Навык выживания:     "
    dict_RU["s.art"] = "Творчество:          "
    dict_RU["s.mus"] = "Музыка:              "
    dict_RU["s.mat"] = "Математика:          "
    dict_RU["s.nla"] = "Родной язык:         "
    dict_RU["s.fla"] = "Иностранные языки:   "
    dict_RU["s.phy"] = "Физика:              "
    dict_RU["s.lit"] = "Литература:          "
    dict_RU["s.tec"] = "Технологии:          "
    dict_RU["s.csc"] = "Информатика:         "
    dict_RU["s.geo"] = "География:           "
    dict_RU["s.soc"] = "Социальные науки:    "
    dict_RU["s.che"] = "Химия:               "
    dict_RU["s.ath"] = "Атлетика:            "
    dict_RU["s.swi"] = "Плавание:            "
    dict_RU["s.dri"] = "Вождение:            "
    dict_RU["s.mar"] = "Боевые искусства:    "
    dict_RU["s.cwe"] = "Холодное оружие:     "
    dict_RU["s.fir"] = "Огнестр. оружие:     "

    // E V E N T S
    dict_RU["name=1"] = "CЕРДЕЧНЫЙ ПРИСТУП"
    dict_RU["desc.s=1"] = "Ваша сердечно-сосудистая система вас подводит. К счастью, скорая помощь поспевает вовремя и спасает вашу жизнь."
    dict_RU["desc.f=1"] = "Ваша сердечно-сосудистая система вас подводит и вы погибаете от сердечного приступа. Скорая помощь не успела вас спасти."
    dict_RU["edesc.s=1"] = "Здоровье: -15"
    dict_RU["edesc.f=1"] = "Вы погибли"
    dict_RU["log.s=1"] = "Пережили сердечный приступ"
    dict_RU["log.f=1"] = "Погибли от сердечного приступа"
    
    return <- dict_RU


def initialize_locales_EN() : table<string; string>

    dict_EN["mode"] = "CHOOSE MODE"

    dict_EN["params.title"] = "SPLIT UP PARAMS"
    dict_EN["params.available"] = "AVAILABLE"
    dict_EN["params.start"] = "START"

    dict_EN["params.will"] = "WIL"
    dict_EN["params.str"] = "STR"
    dict_EN["params.per"] = "PER"
    dict_EN["params.end"] = "END"
    dict_EN["params.cha"] = "CHA"
    dict_EN["params.int"] = "INT"
    dict_EN["params.agi"] = "AGI"
    dict_EN["params.LUC"] = "LUC"

    dict_EN["today"] = " Today"
    dict_EN["next"] = "PROCEED"
    dict_EN["gameover"] = "GAME OVER"
    dict_EN["quit"] = "BACK TO MAIN MENU"

    dict_EN["hp"] = "HP: "
    dict_EN["pp"] = "MH: "
    dict_EN["age"] = "Age:        "
    dict_EN["MON"] = "MON:      "
    dict_EN["infl"] = "INF:  "

    dict_EN["will"] = "WIL:    "
    dict_EN["str"] = "Strength:     "
    dict_EN["per"] = "PER:   "
    dict_EN["end"] = "END:    "
    dict_EN["cha"] = "CHA:     "
    dict_EN["int"] = "INT: "
    dict_EN["agi"] = "AGI:      "
    dict_EN["LUC"] = "LUC:         "

    dict_EN["s.eru"] = "Erudition:           "
    dict_EN["s.emp"] = "Empathy:             "
    dict_EN["s.rhe"] = "Rhetoric:            "
    dict_EN["s.ent"] = "Enterprise:          "
    dict_EN["s.sur"] = "Survivalist:         "
    dict_EN["s.art"] = "Art:                 "
    dict_EN["s.mus"] = "Music:               "
    dict_EN["s.mat"] = "Math:                "
    dict_EN["s.nla"] = "Native language:     "
    dict_EN["s.fla"] = "Foreign languages:   "
    dict_EN["s.phy"] = "Physics:             "
    dict_EN["s.lit"] = "Literature:          "
    dict_EN["s.tec"] = "Technologies:        "
    dict_EN["s.csc"] = "Computer science:    "
    dict_EN["s.geo"] = "Geography:           "
    dict_EN["s.soc"] = "Social studies:      "
    dict_EN["s.che"] = "Chemistry:           "
    dict_EN["s.ath"] = "Athletics:           "
    dict_EN["s.swi"] = "Swimming:            "
    dict_EN["s.dri"] = "Driving:             "
    dict_EN["s.mar"] = "Martial arts:        "
    dict_EN["s.cwe"] = "Cold weapon:         "
    dict_EN["s.fir"] = "Firearms:            "

    // E V E N T S
    dict_EN["name=1"] = "HEART ATTACK"
    dict_EN["desc.s=1"] = "Your cardiovascular system is failing you. LUCily, the ambulance arrives on time and saves your life."
    dict_EN["desc.f=1"] = "Your cardiovascular system fails you and you die of a heart attack. The ambulance did not have time to save you."
    dict_EN["edesc.s=1"] = "HP: -15"
    dict_EN["edesc.f=1"] = "You died"
    dict_EN["log.s=1"] = "Survived a heart attack"
    dict_EN["log.f=1"] = "Died of a heart attack"
    
    return <- dict_EN

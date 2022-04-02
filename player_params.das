module player_params public

enum ParamKey
    AGE_IN_DAYS
    AGE
    HEALTH
    MENTAL
    INFLUENCE
    MONEY
    WILLPOWER
    STRENGHT
    PERCEPTION
    ENDURANCE
    CHARISMA
    INTELLIGENCE
    AGILITY
    LUCK


def pk(param : ParamKey) : int
    return int(param)


struct PlayerParams

    age_in_days : int = 0
    age: int = 0

    health : int = 0
    mental_health : int = 0
    influence : int = 0

    money : int = 0

    willpower : int = 0
    strength : int = 0
    perception: int = 0
    endurance: int = 0
    charisma : int = 0
    intelligence : int = 0
    agility : int = 0
    luck : int = 0
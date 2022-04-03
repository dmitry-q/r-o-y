module player_params public

enum PK
    AGE
    AID
    HP
    MH
    INF
    MON
    WIL
    STR
    PER
    END
    CHA
    INT
    AGI
    LUC


def pk(param : PK) : int
    return int(param)

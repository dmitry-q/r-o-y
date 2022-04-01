require daslib/media
require globals

module date public


enum DateFormat
    ENG
    RU


enum Month
    JANUARY
    FEBRUARY
    MARCH
    APRIL
    MAY
    JUNE
    JULY
    AUGUST
    SEPTEMBER
    OCTOBER
    NOVEMBER
    DECEMBER


struct MonthDuration
    month : Month = Month JANUARY
    duration : int = 31


struct Date
    day : int = 0
    month : int = 0
    year : int = 1970


let MONTHS_DURATIONS : MonthDuration[] <- initialize_months_duration()


def initialize_months_duration : MonthDuration[]
    var md : MonthDuration[12] = [[
        MonthDuration[12]
            [[MonthDuration() month=Month JANUARY, duration=31]];
            [[MonthDuration() month=Month FEBRUARY, duration=28]];
            [[MonthDuration() month=Month MARCH, duration=31]];
            [[MonthDuration() month=Month APRIL, duration=30]];
            [[MonthDuration() month=Month MAY, duration=31]];
            [[MonthDuration() month=Month JUNE, duration=30]];
            [[MonthDuration() month=Month JULY, duration=31]];
            [[MonthDuration() month=Month AUGUST, duration=31]];
            [[MonthDuration() month=Month SEPTEMBER, duration=30]];
            [[MonthDuration() month=Month OCTOBER, duration=31]];
            [[MonthDuration() month=Month NOVEMBER, duration=30]];
            [[MonthDuration() month=Month DECEMBER, duration=31]]
        ]]

    return md


def get_next_date(date : Date) : Date
    var next_date = date
    var expected_day = next_date.day + date_step
    var start_month_duration = MONTHS_DURATIONS[next_date.month].duration

    if expected_day <= start_month_duration - 1
        next_date.day = expected_day
    else
        next_date.month++
        next_date.day = expected_day - start_month_duration
    
    if next_date.month > 11
        next_date.year++
        next_date.month = 0

    return next_date


def format_date(date: Date; format: DateFormat)
    var result : string
    let zero_day = date.day > 8 ? "" : "0"
    let zero_month = date.month > 8 ? "" : "0"

    if format == DateFormat RU
        result = zero_day + string(date.day + 1) + "/" + zero_month + string(date.month + 1) + "/" + string(date.year)
    else
        result = zero_month + string(date.month + 1) + "/" + zero_day + string(date.day + 1) + "/" + string(date.year)

    return result

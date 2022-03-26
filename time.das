require utils/date
require daslib/media
require math
module time public

enum DateFormat
    ENG
    RU

var SCROLL_SPEED : float = 250.0
var SCROLL_ACCELERATION : float = 1.00
var time_jerk : float = 0.0

var TIME_SUM : float = 0.0

var start_date : Date <- set_start_date(0, 0, 1970)
var current_date : Date = start_date
var date_scroll_out_timer : float = 0.0
var event_scroll_out_timer : float = 0.0
var dates : Date[15] <- initialize_dates(current_date)

def set_start_date(day: int; month: int; year: int)
    return [[Date() day=day, month=month, year=year]]

def initialize_dates(start_date: Date) : Date[]
    var initial_dates : Date[15]
    for i in range(0, 14)
        if i == 0
            initial_dates[i] = start_date
        else
            initial_dates[i] = get_next_date(initial_dates[i-1])

    return initial_dates

def update_dates(step: int)
    current_date = dates[1];
    for i in range(0, 14)
        if i < 14 - step
            dates[i] = dates[i+1]
    for j in range(14 - step, 14)
        dates[j] = get_next_date(dates[j-1])

    if SCROLL_ACCELERATION < 1.1864
        SCROLL_ACCELERATION += time_jerk
        //TIME_SUM = get_time_after_start()

    SCROLL_SPEED = pow(250.0, SCROLL_ACCELERATION)

def format_date(date: Date; format: DateFormat)
    var result : string
    let zero_day = date.day > 8 ? "" : "0"
    let zero_month = date.month > 8 ? "" : "0"

    if format == DateFormat RU
        result = zero_day + string(date.day + 1) + "/" + zero_month + string(date.month + 1) + "/" + string(date.year)
    else
        result = zero_month + string(date.month + 1) + "/" + zero_day + string(date.day + 1) + "/" + string(date.year)

    return result

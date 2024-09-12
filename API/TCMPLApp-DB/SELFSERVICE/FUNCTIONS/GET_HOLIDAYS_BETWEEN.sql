create or replace Function selfservice.get_holidays_between(
    p_start_date In Date,
    p_end_date   In Date
) Return Number As
    v_count Number;
Begin
    Select
        Count(*)
    Into
        v_count
    From
        ss_holidays
    Where
        holiday Between p_start_date And p_end_date;
    Return v_count;
Exception
    When Others Then
        Return 0;
End get_holidays_between;
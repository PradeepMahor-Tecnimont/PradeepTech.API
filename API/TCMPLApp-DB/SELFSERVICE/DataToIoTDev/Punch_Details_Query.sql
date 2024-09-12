
With
    max_punch As (
        Select
            n_maxpunch(
                :empnum,
                n_getstartdate(:month, :year),
                last_day(to_date('01-' || :month || '-' || :year, 'dd-mm-yyyy'))
            ) As tot_punch_nos
        From
            dual
    ),
    punch_period As (
        Select
            n_getstartdate(:month, :year)                          As start_date,
            last_day(to_date(:month || ' - ' || :year, 'mm-yyyy')) end_date
        From
            dual
    )
Select
    --main_query.*,
    empno,days, wk_of_year,penaltyhrs,mdate,sday,d_date,shiftcode,islod,issunday,islwd,islcapp,issleaveapp,slappcntr,ego,wrkhrs,tot_punch_nos,
    
     n_deltahrs(:empnum, d_date, shiftcode, penaltyhrs)  deltahrs,
     sum(wrkhrs) over (partition by wk_of_year) as sum_work_hrs,
     sum(n_deltahrs(:empnum, d_date, shiftcode, penaltyhrs)  ) over (partition by wk_of_year) as sum_delta_hrs
From
    (
        Select
            :empnum empno,
            to_char(d_date, 'dd')                                    As days,
            wk_of_year,
            penaltyleave1(

                latecome1(:empnum, d_date),
                earlygo1(:empnum, d_date),
                islastworkday1(:empnum, d_date),

                Sum(islcomeegoapp(:empnum, d_date))
                    Over ( Partition By wk_of_year Order By d_date
                        Range Between Unbounded Preceding And Current Row),

                n_sum_slapp_count(:empnum, d_date),

                islcomeegoapp(:empnum, d_date),
                issleaveapp(:empnum, d_date)
            )                                                        As penaltyhrs,

            to_char(d_date, 'dd-Mon-yyyy')                           As mdate,
            d_dd                                                     As sday,
            d_date,
            getshift1(:empnum, d_date)                               As shiftcode,
            isleavedeputour(d_date, :empnum)                         As islod,
            get_holiday(d_date)                                      As issunday,
            islastworkday1(:empnum, d_date)                          As islwd,
            lc_appcount(:empnum, d_date)                             As islcapp,
            issleaveapp(:empnum, d_date)                             As issleaveapp,

            n_sum_slapp_count(:empnum, d_date)                       As slappcntr,

            earlygo1(:empnum, d_date)                                As ego,
            n_workedhrs(:empnum, d_date, getshift1(:empnum, d_date)) As wrkhrs,
            max_punch.tot_punch_nos

        From
            ss_days_details, max_punch, punch_period
        Where
            d_date Between punch_period.start_date And punch_period.end_date
        Order By d_date
    ) main_query

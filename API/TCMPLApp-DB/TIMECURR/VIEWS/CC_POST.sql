--------------------------------------------------------
--  DDL for View CC_POST
--------------------------------------------------------

Create Or Replace Force Editionable View "TIMECURR"."CC_POST" (
    "ASSIGN",
    "DESC1",
    "NOOFEMPL"
) As
    (
        Select
            e.assign, 'Employee Not Filled' desc1, Count(*) As noofempl
        From
            emplmast  e,
            deptphase dp
        Where
            e.assign         = dp.costcode
            And dp.isprimary = 1
            And e.empno Not Like 'ST%'
            And e.status     = 1
            And (e.empno Not In (
                    Select
                        empno
                    From
                        time_mast
                    Where
                        yymm = (
                            Select
                                pros_month
                            From
                                tsconfig
                        )
                ) AND e.empno Not In (
                    Select
                        empno
                    From
                        ts_osc_mhrs_master
                    Where
                        yymm = (
                            Select
                                pros_month
                            From
                                tsconfig
                        )
                ))
        Group By
            e.assign

        Union All

        Select
            c.costcode As assign, 'None in CostCode filled' desc1, Count(*) As noofempl
        From
            costmast  c,
            deptphase dp
        Where
            c.closed <> 1
            And c.costcode   = dp.costcode
            And dp.isprimary = 1
            And (c.costcode Not In
                (
                    Select
                        assign
                    From
                        time_mast
                    Where
                        yymm = (
                            Select
                                pros_month
                            From
                                tsconfig
                        )
                ) AND c.costcode Not In
                (
                    Select
                        assign
                    From
                        ts_osc_mhrs_master
                    Where
                        yymm = (
                            Select
                                pros_month
                            From
                                tsconfig
                        )
                ))
        Group By
            c.costcode

        Union All

        Select
            assign, 'Not Posted' desc1, Count(assign) noofempl
        From
            (
                Select
                    assign
                From
                    time_mast
                Where
                    yymm       = (
                              Select
                                  pros_month
                              From
                                  tsconfig
                          )
                    And posted = 0

                Union All

                Select
                    assign
                From
                    ts_osc_mhrs_master
                Where
                    yymm        = (
                               Select
                                   pros_month
                               From
                                   tsconfig
                           )
                    And is_post = 'KO'
            )
        Group By
            assign
    );
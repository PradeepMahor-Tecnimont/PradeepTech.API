--------------------------------------------------------
--  DDL for View CHECK_POSTED
--------------------------------------------------------

Create Or Replace Force View "TIMECURR"."CHECK_POSTED" (
    "HOD",
    "COSTCODE",
    "NAME",
    "NOOFEMPS"
) As
    (
        Select
            hod, costcode, name, noofemps
        From
            costmast
        Where
            costcode In
            (
                Select
                Distinct costcode
                From
                    costmast
                Where
                    costcode
                    Not In (
                        Select
                        Distinct costcode
                        From
                            timetran
                        Where
                            yymm = (
                                Select
                                    pros_month
                                From
                                    tsconfig
                            )
                    )
            )
            And noofemps <> 0
            --And costcode Like '02%' -- Old
            And costcode In (
                Select
                    costcode
                From
                    deptphase
                Where
                    isprimary = 1
            )
    );
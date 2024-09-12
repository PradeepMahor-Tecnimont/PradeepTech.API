--------------------------------------------------------
--  DDL for View CC_POST_DET
--------------------------------------------------------

Create Or Replace Force Editionable View "TIMECURR"."CC_POST_DET" (
    "EMPTYPE",
    "ASSIGN",
    "COSTNAME",
    "HOD",
    "DESC1",
    "EMPNO",
    "NAME",
    "DOJ",
    "EMAIL",
    "DOL"
) As
    (
        Select
            a.emptype, a.assign, b.name As costname, b.hod, 'Timesheet Not Filled' desc1, a.empno, a.name, a.doj, a.email, a.
            dol
        From
            emplmast             a, 
            costmast b,
            deptphase dp
        Where
            a.assign = dp.costcode
            And dp.isprimary = 1
            And a.assign = b.costcode
            And a.status = 1
            And a.emptype In ('C', 'R', 'S', 'F')
            And a.empno Not In
            (
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
            )
        Union
        Select
            b.emptype, a.assign, c.name As costname, c.hod, 'Timesheet Not Locked' desc1, a.empno, b.name, b.doj, b.email, b.
            dol
        From
            time_mast             a, 
            emplmast b,
            costmast c
        Where
            a.assign             = c.costcode
            And a.yymm           = (
                          Select
                              pros_month
                          From
                              tsconfig
                      )
            And nvl(a.locked, 0) = 0
            And a.empno          = b.empno
            And b.emptype In ('C', 'R', 'S', 'F')
        Union
        Select
            b.emptype, a.assign, c.name As costname, c.hod, 'Timesheet Not Approved' desc1, a.empno, b.name, b.doj, b.email, b.
            dol
        From
            time_mast             a, 
            emplmast b,
            costmast c
        Where
            a.assign               = c.costcode
            And a.yymm             = (
                            Select
                                pros_month
                            From
                                tsconfig
                        )
            And nvl(a.approved, 0) = 0
            And a.empno            = b.empno
            And b.emptype In ('C', 'R', 'S', 'F')
        Union
        Select
            b.emptype, a.assign, c.name As costname, c.hod, 'Timesheet Not Posted' desc1, a.empno, b.name, b.doj, b.email, b.
            dol
        From
            time_mast             a, 
            emplmast b,
            costmast c
        Where
            a.assign             = c.costcode
            And a.yymm           = (
                          Select
                              pros_month
                          From
                              tsconfig
                      )
            And nvl(a.posted, 0) = 0
            And a.empno          = b.empno
            And b.emptype In ('C', 'R', 'S', 'F')
    );
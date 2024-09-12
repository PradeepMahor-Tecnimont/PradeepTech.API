--------------------------------------------------------
--  DDL for View CC_POST_DET_O
--------------------------------------------------------

Create Or Replace Force Editionable View "TIMECURR"."CC_POST_DET_O" (
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
            e.emptype, e.assign, c.name As costname, c.hod, 'Timesheet Not Filled' desc1, e.empno, e.name, e.doj, e.email, e.
            dol
        From
            emplmast  e,
            costmast  c,
            deptphase dp
        Where
            e.assign         = c.costcode
            And e.assign     = dp.costcode
            And e.status     = 1
            And e.emptype    = 'O'
            And dp.isprimary = 1
            And Not Exists
            (
                Select
                    empno
                From
                    ts_osc_mhrs_master                tomm, tsconfig t
                Where
                    tomm.yymm      = t.pros_month
                    And tomm.empno = e.empno
            )

        Union All

        Select
            e.emptype,
            tomm.assign,
            c.name As costname,
            c.hod,
            Case
                When nvl(tomm.is_lock, 'KO') = 'KO' Then
                    'Timesheet Not Locked'
                When nvl(tomm.is_hod_approve, 'KO') = 'KO' Then
                    'Timesheet Not Approved'
                When nvl(tomm.is_post, 'KO') = 'KO' Then
                    'Timesheet Not Posted'
                Else
                    'POSTED'
            End    desc1,
            tomm.empno,
            e.name,
            e.doj,
            e.email,
            e.dol
        From
            ts_osc_mhrs_master tomm,
            emplmast           e,
            costmast           c,
            tsconfig           t,
            deptphase          dp
        Where
            e.assign         = c.costcode
            And tomm.yymm    = t.pros_month
            And tomm.empno   = e.empno
            And e.emptype    = 'O'
            And e.assign     = dp.costcode
            And dp.isprimary = 1
    );
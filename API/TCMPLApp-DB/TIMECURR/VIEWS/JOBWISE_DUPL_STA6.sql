--------------------------------------------------------
--  DDL for View JOBWISE_DUPL_STA6
--------------------------------------------------------

Create Or Replace Force View "TIMECURR"."JOBWISE_DUPL_STA6" (
    "YYMM",
    "PARENT",
    "ASSIGN",
    "PROJNO",
    "EMPNO",
    "ACTIVITY",
    "WPCODE",
    "HOURS",
    "OTHOURS"
) As
    Select
        yymm, parent, assign, projno, empno, activity, wpcode, Sum(hours) As hours, Sum(othours) As othours
    From
        (
            Select
                yymm, parent, assign, projno, empno, activity, wpcode, total As hours, 000.00 As othours
            From
                time_daily
            Union All
            Select
                yymm, parent, assign, projno, empno, activity, wpcode, 000.00 As hours, total As othours
            From
                time_ot
        )
        Group By
        yymm, parent, assign, projno, empno, activity, wpcode;
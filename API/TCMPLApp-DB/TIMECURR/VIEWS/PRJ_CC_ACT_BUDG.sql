--------------------------------------------------------
--  DDL for View PRJ_CC_ACT_BUDG
--------------------------------------------------------

Create Or Replace Force View "TIMECURR"."PRJ_CC_ACT_BUDG" (
    "PROJNO",
    "COSTCODE",
    "TOTHRS",
    "REVISED",
    "COSTNAME",
    "NAME"
) As
    (
        Select
            a."PROJNO", a."COSTCODE", a."TOTHRS", nvl(b.revised, 0) As "REVISED", c.name costname, d.name
        From
            proj_costcode             a, budgmast b, costmast c, projmast d
        Where
            a.costcode     = c.costcode
            And a.projno   = d.projno
            And a.projno   = b.projno(+)
            And a.costcode = b.costcode(+)
    );
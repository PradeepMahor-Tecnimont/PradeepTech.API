--------------------------------------------------------
--  DDL for View RAP_VU_RPT_BREAKUP
--------------------------------------------------------


  CREATE OR REPLACE FORCE VIEW "TIMECURR"."RAP_VU_RPT_BREAKUP" ("YYMM", "COSTCODE", "TMAGRP", "TOTHOURS") AS 
  Select
        a.yymm, a.costcode, Trim(b.tmagrp) tmagrp, nvl(Sum(hours) + Sum(othours), 0) tothours
    From
        timetran                   a, job_proj_phase b
    Where
        a.projno = b.projno || b.phase_select
    Group By
        a.yymm, a.costcode, b.tmagrp
    Union
    Select
        a.yymm, a.costcode, Trim(b.tmagrp) tmagrp, nvl(Sum(hours) + Sum(othours), 0) tothours
    From
        time2021.timetran                   a, job_proj_phase b
    Where
        a.projno = b.projno || b.phase_select
    Group By
        a.yymm, a.costcode, b.tmagrp
    Union
    Select
        a.yymm, a.costcode, Trim(b.tmagrp) tmagrp, nvl(Sum(hours) + Sum(othours), 0) tothours
    From
        time2020.timetran                   a, job_proj_phase b
    Where
        a.projno = b.projno || b.phase_select
    Group By
        a.yymm, a.costcode, b.tmagrp
    Union
    Select
        a.yymm, a.costcode, Trim(b.tmagrp) tmagrp, nvl(Sum(hours) + Sum(othours), 0) tothours
    From
        time2019.timetran                   a, job_proj_phase b
    Where
        a.projno = b.projno || b.phase_select
    Group By
        a.yymm, a.costcode, b.tmagrp

    Union
    Select
        a.yymm, a.costcode, Trim(b.tmagrp) tmagrp, nvl(Sum(hours) + Sum(othours), 0) tothours
    From
        time2018.timetran                   a, job_proj_phase b
    Where
        a.projno = b.projno || b.phase_select
    Group By
        a.yymm, a.costcode, b.tmagrp

    Union
    Select
        a.yymm, a.costcode, Trim(b.tmagrp) tmagrp, nvl(Sum(hours) + Sum(othours), 0) tothours
    From
        time2017.timetran                   a, job_proj_phase b
    Where
        a.projno = b.projno || b.phase_select
    Group By
        a.yymm, a.costcode, b.tmagrp;


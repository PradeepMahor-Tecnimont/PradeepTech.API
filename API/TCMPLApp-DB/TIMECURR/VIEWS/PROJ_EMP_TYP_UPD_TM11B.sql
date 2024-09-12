--------------------------------------------------------
--  DDL for View PROJ_EMP_TYP_UPD_TM11B
--------------------------------------------------------

Create Or Replace View timecurr.proj_emp_typ_upd_tm11b As
    Select
        g.newcostcode,
        b.emptype,
        a.yymm,
        a.costcode,
        a.activity,
        a.parent,
        e.name                        As parentname,
        g.tcmno,
        substr(a.projno, 1, 5)        projno5,
        a.projno,
        g.name                        projname,
        a.wpcode,
        a.empno,
        b.name,
        c.description                 vendor,
        d.description                 phasedescription,
        Sum(a.hours)                  hours,
        Sum(a.othours)                othours,
        Sum(a.hours) + Sum(a.othours) totalhrs
    From
        timetran             a, emplmast b, subcontractmast c, job_phases d, costmast e, emptypemast f, projmast g
    Where
        a.empno                    = b.empno
        And b.subcontract          = c.subcontract(+)
        And substr(a.projno, 6, 2) = d.phase
        And a.costcode             = e.costcode
        And b.emptype              = f.emptype
        And a.projno               = g.projno
    Group By
        g.newcostcode,
        b.emptype,
        a.yymm,
        a.costcode,
        a.activity,
        a.parent,
        e.name,
        g.tcmno,
        substr(a.projno, 1, 5),
        a.projno,
        g.name,
        a.wpcode,
        a.empno,
        b.name,
        c.description,
        d.description;

Grant Select On "TIMECURR"."PROJ_EMP_TYP_UPD_TM11B" To "TCMPL_APP_CONFIG";
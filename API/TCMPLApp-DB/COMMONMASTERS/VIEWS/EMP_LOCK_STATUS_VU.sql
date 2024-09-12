--------------------------------------------------------
--  DDL for View EMP_LOCK_STATUS_VU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "COMMONMASTERS"."EMP_LOCK_STATUS_VU" ("EMPNO", "NAME", "EMP_COSTCODE", "COSTDESC", "PRIM_LOCK", "NOM_LOCK", "FMLY_LOCK", "LOGIN_LOCK", "ADHAAR_LOCK", "PP_LOCK", "GTLI_LOCK") AS 
  Select
    b.empno
  , b.name
  , b.parent    emp_costcode
  , c.name      costdesc
  , a.prim_lock
  , a.nom_lock
  , a.fmly_lock
  , a.login_lock
  , a.adhaar_lock
  , a.pp_lock
  , a.gtli_lock
From
    (
        Select
            a.empno              empno
          , a.prim_lock_open     prim_lock
          , a.nom_lock_open      nom_lock
          , a.fmly_lock_open     fmly_lock
          , a.login_lock_open    login_lock
          , a.adhaar_lock
          , a.pp_lock
          , a.gtli_lock
        From
            emp_lock_status a
        Union
        Select
            empno
          , 1  prim_lock
          , 1  nom_lock
          , 1  fmly_lock
          , 1  login_lock
          , 1  adhaar_lock
          , 1  pp_lock
          , 1  gtli_lock
        From
            emplmast
        Where
                status = 1
            And doj >= add_months(sysdate, - 1)
            And empno Not In (
                Select
                    empno
                From
                    emp_lock_status
            )
            And emptype = 'R'
        Union
        Select
            empno
          , - 1  prim_lock
          , - 1  nom_lock
          , - 1  fmly_lock
          , - 1  login_lock
          , - 1  adhaar_lock
          , - 1  pp_lock
          , - 1   gtli_lock
        From
            emplmast
        Where
                status = 1
            And doj < add_months(sysdate, - 1)
            And empno Not In (
                Select
                    empno
                From
                    emp_lock_status
            )
            And emptype = 'R'
    )         a
  , emplmast  b
  , costmast  c
Where
        b.empno = a.empno (+)
    And b.parent = c.costcode
    And b.status = 1
    And b.emptype = 'R'
    And b.status = 1
;

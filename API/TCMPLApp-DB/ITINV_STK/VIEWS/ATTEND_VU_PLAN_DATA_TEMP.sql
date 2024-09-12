--------------------------------------------------------
--  DDL for View ATTEND_VU_PLAN_DATA_TEMP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ITINV_STK"."ATTEND_VU_PLAN_DATA_TEMP" ("EMPNO", "NAME", "PARENT", "ASSIGN", "ATTENDING_OFFICE", "MODELER", "SHIFT", "BUS", "STATION", "SIDE", "CITY_LANDMARK", "TASKFORCE", "SPECIAL_NOTE") AS 
  Select
        e.empno,
        e.name,
        e.parent,
        e.assign,
        attending_office,
        modeler,
        shift,
        bus,
        station,
        side,
        city_landmark,
        taskforce,
        special_note
    From
        attend_plan_data_temp  apdt,
        vu_emplmast            e
    Where
        apdt.empno = e.empno
    Union All
    Select
        empno,
        name,
        parent,
        assign,
        0     attending_office,
        0     modeler,
        Null  shift,
        Null  bus,
        Null  station,
        Null  side,
        Null  city_landmark,
        Null  taskforce,
        Null  special_note
    From
        vu_emplmast e
    Where
            status = 1
        And Not Exists (
            Select
                *
            From
                attend_plan_data_temp apdt
            Where
                apdt.empno = e.empno
        )
    Order By
        empno
;

--------------------------------------------------------
--  DDL for View DIST_DESMAS_ALLOCATION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ITINV_STK"."DIST_DESMAS_ALLOCATION" ("EMPNO", "DESKID", "COMPNAME", "QR_CODE", "COMP_TYPE", "PC_RAM", "PCMODEL", "PC_GCARD", "MONMODEL1", "MONITOR_COUNT") AS 
  Select
    empno1 empno,
    deskid,
    compname,
    computer qr_code,
    case substr(computer,1,7) when 'IT087PC' then 'PC' when 'IT085NB' then 'LAPTOP' else '' end comp_type,
    pc_ram,
    pcmodel,
    pc_gcard,
    monmodel1,
    Case
        When monitor1 Is Not Null
             And monitor2 Is Not Null Then
            2
        
        when monitor1 is not null or monitor2 is not null then
            1
            else null
    End monitor_count
    
From
    dm_vu_desmas_allocation
Where
    Trim(empno1) Is Not Null
Union
Select
    empno2,
    deskid,
    compname,
    computer,
    case substr(computer,1,7) when 'IT087PC' then 'PC' when 'IT085NB' then 'LAPTOP' else '' end device_type,
    pc_ram,
    pcmodel,
    pc_gcard,
    monmodel1,
    Case
        When monitor1 Is Not Null
             And monitor2 Is Not Null Then
            2
        
        when monitor1 is not null or monitor2 is not null then
            1
            else null
    End monitor_count
From
    dm_vu_desmas_allocation
Where
    Trim(empno2) Is Not Null
;

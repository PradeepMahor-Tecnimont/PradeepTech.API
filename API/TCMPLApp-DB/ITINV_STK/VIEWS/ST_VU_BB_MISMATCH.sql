--------------------------------------------------------
--  DDL for View ST_VU_BB_MISMATCH
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ITINV_STK"."ST_VU_BB_MISMATCH" ("KEY_ID", "EMPNO", "EMP_NAME", "PARENT", "OLD_PC_NAME", "CURR_PC_NAME", "MIS_MATCH_STATUS", "REMARK_1", "REMARK_2", "VERSION") AS 
  Select
    key_id,
    empno,
    emp_name,
    parent,
    pc_name old_pc_name,
    curr_pc_name,
    Case
        When pc_name <> curr_pc_name Then
            'PC MisMatch'
        Else
            Null
    End mis_match_status,
    'Uninstall From "' || pc_name || '"' remark_1,
    Case
        When curr_pc_name Like 'ERRRR%' Then
            Null
        Else
            'INSTALL on "' || curr_pc_name || '"'
    End remark_2,
    version
From
    (
        Select
            a.key_id,
            a.empno,
            get_emp_name(
                a.empno
            ) emp_name,
            c.parent,
            a.pcname pc_name,
            Nvl(b.compname, 'ERRRR') curr_pc_name,
            a.version
        From
            bb_emp_pc_log        a,
            dm_vu_user_desk_pc   b,
            vu_emplmast          c
        Where
            a.empno = c.empno (+)
            And ( a.empno = b.empno (+) )
            And a.delete_flag = 0
    )
Where
    pc_name <> curr_pc_name
;

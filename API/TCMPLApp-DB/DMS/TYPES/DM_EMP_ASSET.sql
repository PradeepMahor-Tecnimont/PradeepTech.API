--------------------------------------------------------
--  DDL for Type DM_EMP_ASSET
--------------------------------------------------------

  CREATE OR REPLACE TYPE "DM_EMP_ASSET" as object (
    p_empno varchar2(5), 
    p_assetid varchar2(13), 
    p_source varchar2(20), 
    p_remarks varchar2(100)
);

/

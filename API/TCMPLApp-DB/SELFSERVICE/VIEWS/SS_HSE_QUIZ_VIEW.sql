--------------------------------------------------------
--  DDL for View SS_HSE_QUIZ_VIEW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_HSE_QUIZ_VIEW" ("EMPNO", "NAME", "IMPROVE", "ISO_VER", "HSE_PROC", "HSE_DOC", "HSE_PROJPLAN", "EMERGENCY", "EMERGENCYPHONE", "FLAG_WHERE", "FLAG_ADD", "FLAG_ENVIR", "FLAG_HELT_HAZ", "FLAG_HSE_REQ", "FLAG_HSE_OBJ", "FLAG_INCIDENTS", "FLAG_AUDITS", "SEND_TO_HSE", "APPROVE", "COSTCODE", "COSTCODEDESC") AS 
  (
SELECT a."EMPNO", b.name, a."IMPROVE",a."ISO_VER",a."HSE_PROC",a."HSE_DOC",a."HSE_PROJPLAN",a."EMERGENCY",a."EMERGENCYPHONE",a."FLAG_WHERE",a."FLAG_ADD",a."FLAG_ENVIR",a."FLAG_HELT_HAZ",a."FLAG_HSE_REQ",a."FLAG_HSE_OBJ",a."FLAG_INCIDENTS",a."FLAG_AUDITS",a."SEND_TO_HSE",a."APPROVE"           ,
  b.parent AS CostCode,
  c.name   AS CostCodeDesc
   FROM ss_hse_quiz A,
  SS_Emplmast B      ,
  ss_costmast C
  WHERE a.empno = b.empno
AND b.parent    = c.costcode
)
;

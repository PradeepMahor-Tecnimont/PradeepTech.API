--------------------------------------------------------
--  DDL for Procedure DEL_OD_APP
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "DEL_OD_APP" 
(
  p_APP_NO IN VARCHAR2  
, p_Tab_From IN VARCHAR2  
) AS 
  v_EmpNo char(5);
  v_PDate date;
BEGIN
  If Trim(p_Tab_From) = 'DP' Then
    Delete from SS_Depu where app_no = p_app_No;
  ElsIf Trim(p_Tab_From) = 'OD' Then
    Select distinct empno, PDATE InTo v_EmpNo, v_PDate from (
      Select distinct empno, PDATE from ss_ondutyapp where Trim(APP_NO) = trim(p_app_no) ) where rownum=1;
    Delete from SS_OndutyApp where trim(app_no) = trim(p_app_no);
    Delete from SS_Onduty where trim(app_no) = trim(p_app_no);
    generate_auto_punch(v_empno, v_pdate);
  End If;
END DEL_OD_APP;

/

--------------------------------------------------------
--  DDL for Procedure DELETELEAVE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "DELETELEAVE" (AppNum In Varchar2) IS
	v_count Number:=0;
BEGIN  
  --check in ss_leaveapp table
  Select Count(app_no) Into v_count From ss_leaveapp
  	Where app_no = Trim(AppNum);
  If v_count > 0 Then
  	Delete From ss_leaveapp Where app_no = Trim(AppNum);
  End If;	
  
  --check in ss_leaveledg table
  Select Count(app_no) Into v_count From ss_leaveledg
  	Where app_no = Trim(AppNum);
  If v_count > 0 Then
  	Delete From ss_leaveledg Where app_no = Trim(AppNum);
  End If;	

  --check in ss_leave_adj table
  Select Count(adj_no) Into v_count From ss_leave_adj
  	Where adj_no = Trim(AppNum);
  If v_count > 0 Then
  	Delete From ss_leave_adj Where adj_no = Trim(AppNum);
  End If;	

  Select Count(new_app_no) Into v_count From ss_pl_revision_mast 
  	Where trim(new_app_no) = Trim(AppNum);
  If v_count > 0 Then
  	Delete From ss_pl_revision_mast Where trim(new_app_no) = Trim(AppNum);
  End If;	

END;

/

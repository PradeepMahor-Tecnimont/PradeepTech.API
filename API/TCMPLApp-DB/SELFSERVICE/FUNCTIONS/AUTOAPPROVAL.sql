--------------------------------------------------------
--  DDL for Function AUTOAPPROVAL
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."AUTOAPPROVAL" (EmpNum Varchar2) RETURN Number IS
	Cursor cur_leave Is 
		Select app_no From ss_leaveapp 
		Where ((sysdate - app_date) > 7) And hod_apprl = 0 For Update Of hod_apprl;

	Cursor cur_onduty Is 
		Select app_no From ss_ondutyapp
		Where ((sysdate - app_date) > 7) And hod_apprl = 0 For Update Of hod_apprl;

	Cursor cur_depu Is 
		Select app_no From ss_depu
		Where ((sysdate - app_date) > 7) And hod_apprl = 0 For Update Of hod_apprl;
 	var_TcpIp Varchar2(30);
BEGIN
	Select tcp_ip Into var_TcpIp From ss_usermast Where empno = Trim(EmpNum);	
  For c1 In cur_leave Loop
  	Update ss_leaveapp
  		Set hod_apprl = 1, hod_apprl_dt = sysdate, hod_tcp_ip = Trim(var_TcpIp), 
  				hod_code = Trim(EmpNum)
  		Where Current Of cur_leave;  	
  End Loop;

  For c2 In cur_onduty Loop
  	Update ss_ondutyapp
  		Set hod_apprl = 1, hod_apprl_dt = sysdate, hod_tcp_ip = Trim(var_TcpIp),
  			  hod_code = Trim(EmpNum)
  		Where Current Of cur_onduty;  	
  End Loop;

  For c3 In cur_depu Loop
  	Update ss_depu
  		Set hod_apprl = 1, hod_apprl_dt = sysdate, hod_tcp_ip = Trim(var_TcpIp),
  			  hod_code = Trim(EmpNum)
  		Where Current Of cur_depu;  	
  End Loop;

  Commit;
  Return 1;

Exception
	When Others Then
		Return 0;  	
END;


/

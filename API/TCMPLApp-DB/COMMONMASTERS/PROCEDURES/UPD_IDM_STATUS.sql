--------------------------------------------------------
--  DDL for Procedure UPD_IDM_STATUS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "COMMONMASTERS"."UPD_IDM_STATUS" AS 
   	V_Company_Id   Char(4); 
   	V_Employee_Id    Char(16);	 
    V_Metaid   Char(20);
    V_Company_Email Varchar(450);
    V_User_Status Number(1);
    V_Domain Varchar2(250);
    V_Account_Name Varchar(20);
    V_Count Number(1);
   	    
   	Cursor C1  Is  
   		Select *  From Idm_Status_Sql	Order by company_id,employee_id;    
      
Begin   
   	Open C1;
    Loop
    Fetch C1 Into V_Company_Id,V_Employee_Id,V_Metaid,V_Company_Email,V_User_Status,V_Domain,V_Account_Name;
    Exit When C1%NotFound ;
    V_Count := 0;
    Select Count(*) Into V_Count From Idm_Status  Where Company = V_Company_Id And Empno = substr(V_Employee_Id,12,5);		   
    If V_Count = 0 Then
      Insert Into Idm_Status (Company,EmpNo,Metaid,Company_Email,User_Status,Domain,Account_Name)	values    (v_Company_Id,substr(v_Employee_Id,12,5),v_Metaid,v_Company_Email,v_User_Status,V_Domain,V_Account_Name) ; 
    Else
      Update Idm_Status  Set       Metaid = V_Metaid,
      Company_Email  = V_Company_Email,
      User_Status = V_User_Status,
      Domain = V_Domain,
      Account_Name = V_Account_Name
      Where  Company = V_Company_Id And Empno = substr(V_Employee_Id,12,5) ;
    End If;
    Commit; 
      V_Metaid := '';
    V_Company_Email := '';
    V_User_Status := 0;
    V_Company_Id := '';
    V_Employee_Id := '';
    V_Domain := '';
    V_Account_Name := '';
    
    End Loop;
    close c1;
    
    
   
END;

/

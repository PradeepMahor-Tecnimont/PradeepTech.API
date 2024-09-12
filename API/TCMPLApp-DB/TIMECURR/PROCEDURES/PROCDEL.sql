--------------------------------------------------------
--  DDL for Procedure PROCDEL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "TIMECURR"."PROCDEL" (p_projno Varchar2, p_sid Varchar2, p_month Varchar2)   
IS   
   	vProjNo   char(5); 
   	vPhase    char(2);	 
   	vSid      char(80); 
   	vMonth    char(6);   
   	i         number;         
   	Type TypeRevBudg Is table of tp_xls.revbudg%Type ; 
    varTab TypeRevBudg;    
   	v_Costcode char(4); 
   	v_RevOpen number; 
   	v_RevBal  number; 
   	v_Intial  number; 
   	v_Revise  number; 
        
   	Cursor cur_costcode (c_Projno varchar2, c_Sid Varchar2) Is  
   		Select distinct costcode From tp_xls 
   			Where Projno = Trim(c_Projno) and Sessionid = rpad(Trim(c_Sid),80,' ') 
   				Order by costcode;    
      
BEGIN   
   	vProjNo 	:= SubStr(Trim(p_projNo) || '     ',1,5);   
   	--vPhase  	:= SubStr(Trim(p_phase) || '     ',1,2); 
   	vSid    	:= rpad(Trim(p_sid),80,' '); 
   	vMonth  	:= SubStr(Trim(p_month) || '     ',1,6); 
    v_RevOpen :=0; 
   	v_RevBal  :=0;
   		   
    /* Copy table job_budgtran to tp_job_budgtran  (w.r.t. Sessionid) */
     
    Insert into tp_job_budgtran (projno,costcode,yymm,initbudg,revbudg,phase,sessionid)	 
      Select projno,costcode,yymm,initbudg,revbudg,phase,vSID From job_budgtran Where Projno = vProjNo;		   
    Commit; 
    
    /* Copy table jobbudget to tp_jobbudget  (w.r.t. Sessionid) */
    
    Insert into tp_jobbudget (projno,phase,costgrp,costcode,cc,intialbudget,mnth01,mnth02,mnth03,mnth04,mnth05,mnth06, 
      mnth07,mnth08,mnth09,mnth10,mnth11,mnth12,balance,revisedbudget,openbudg,sessionid)	 
        Select projno,phase,costgrp,costcode,cc,intialbudget,mnth01,mnth02,mnth03,mnth04,mnth05,mnth06,mnth07, 
          mnth08,mnth09,mnth10,mnth11,mnth12,balance,revisedbudget,openbudg,vSid From jobbudget  
            Where Projno = vProjNo; 
    Commit;	   	 
   
    /* Copy excel data (tp_xls) to job_budgtran  (w.r.t. Sessionid) */  
    
    Delete From job_budgtran Where Projno = vProjNo; 
    Commit; 
    
    Insert into job_budgtran (projno,costcode,yymm,initbudg,revbudg,phase)  
      Select projno,costcode,yymm,initbudg,revbudg,phase From tp_xls  
        Where Projno = vProjNo and Sessionid = vSid
          and (initbudg <> 0 or revbudg <> 0) ;
    Commit;		   
   		 
    /* Copy excel data (tp_xls) to jobbudget  (w.r.t. Sessionid)  */
		  
		  Delete From jobbudget Where Projno = vProjNo;  
		  Commit;		   
	   	For c1 in cur_costcode(vProjno, vSid) Loop	   		
		   		/* Total Intial and revised budget */
			   		Select costcode, sum(nvl(initbudg,0)), sum(nvl(revbudg,0)) into v_Costcode,v_Intial,v_Revise From tp_xls  
			   			Where Projno = vProjNo and Sessionid = vSid and Costcode = c1.costcode 
			   				Group By costcode;
		   				
		   		/* Opening balance for revised budget */
		   			Begin
					   		Select sum(nvl(revbudg,0)) into v_RevOpen From tp_xls  
					   			Where Projno = vProjNo and Sessionid = vSid and yymm < vMonth and Costcode = c1.costcode 
					   				Group By costcode;
					   		If v_RevOpen > 0 Then
									v_RevOpen := v_RevOpen;
								End If;
		   			Exception
		   					When no_data_found Then
									v_RevOpen := 0;
		   			End;
		   				
		   		/* Balance revised budget	*/ 
		   			Begin
              Select sum(nvl(revbudg,0)) into v_RevBal from
                (Select a.*, rownum rnum From tp_xls a Where Projno = vProjNo and Sessionid = vSid  
                  and yymm >= vMonth and costcode = c1.costcode Order by rnum desc) 
                    Where yymm >= to_char(ADD_MONTHS(to_date(vMonth,'yyyymm'),12),'YYYYMM') Group by costcode;								
								If v_RevBal > 0 Then
									v_RevBal := v_RevBal;
								End If;
						Exception
								When no_data_found Then
									v_RevBal := 0;
						End;
						
					/* Budget for 12 months */				          	          
		      	
		      		Select revbudg bulk collect into varTab from 
			   				(Select * from tp_xls where yymm >= vMonth and costcode = c1.costcode 
		               and Projno = vProjNo and Sessionid = vSid Order by costcode, yymm)
                      Where yymm >= to_char(to_date(vMonth,'yyyymm')) and
                          yymm < to_char(ADD_MONTHS(to_date(vMonth,'yyyymm'),12),'YYYYMM');
		      	
		      	
		      	If varTab.Count < 12 Then
		      		varTab.extend( 12 - varTab.Count );
		      	End if;	
            Select phase into vPhase from deptphase where costcode = v_costcode;
	   	 			Insert into jobbudget (projno,phase,costgrp,costcode,cc,intialbudget,mnth01,mnth02,mnth03,
	   	 					mnth04,mnth05,mnth06,mnth07,mnth08,mnth09,mnth10,mnth11,mnth12,balance,revisedbudget,openbudg) 
               values (vProjNo,vPhase,'-',v_Costcode,'-',v_Intial,nvl(varTab(1),0),nvl(varTab(2),0),nvl(varTab(3),0),
                nvl(varTab(4),0),nvl(varTab(5),0),nvl(varTab(6),0),nvl(varTab(7),0),nvl(varTab(8),0),nvl(varTab(9),0),
                nvl(varTab(10),0),nvl(varTab(11),0),nvl(varTab(12),0),v_RevBal,v_Revise,v_RevOpen);     
               
	   	End Loop; 
	   	Commit;
	   	
      /* Delete data from temporary tables (w.r.t. Sessionid) */
    
  	 	Delete From tp_xls Where Projno = vProjno and Sessionid = vSid; 
   		Delete From tp_job_budgtran Where Projno = vProjno and Sessionid = vSid;  
  		Delete From tp_jobbudget Where Projno = vProjno and Sessionid = vSid;  
   		Commit;		
END;

/

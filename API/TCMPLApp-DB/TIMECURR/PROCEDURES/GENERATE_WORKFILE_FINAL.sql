--------------------------------------------------------
--  DDL for Procedure GENERATE_WORKFILE_FINAL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "TIMECURR"."GENERATE_WORKFILE_FINAL" (p_processing_month in timetran.yymm%type,p_prevyear number := 0) IS  
   v_projno projmast.projno%type;        
   v_tcm_no projmast.tcmno%type;        
   v_loopprojno projmast.projno%type;        
   v_costcode costmast.costcode%type;        
   v_loopcostcode costmast.costcode%type;        
   v_cumm_ticbhrs number(12,2) :=0.00;        
   v_cumm_subchrs number(12,2) :=0.00;        
   v_ticbhrs number(12,2) :=0.00;        
   v_subchrs number(12,2) :=0.00;        
   v_total_ticb number(12,2) :=0.00;        
   v_total_subc number(12,2) :=0.00;         
   v_total_inv number(12,2) :=0.00;        
   v_rates number(1) :=0;        
   v_suborder_no inv_loa_details.suborder_no%type;        
   v_loa_no inv_loa_details.loa_no%type;        
        
   v_budgetted number(12,2) :=0.00;        
   v_revised number(12,2) :=0.00;        
   v_ticbconsumed number(12,2) :=0.00;        
   v_subcconsumed number(12,2) :=0.00;        
   v_invoiced number(12,2) :=0.00;        
   v_invoiced_amount number(12,2) :=0.00;        
   v_delta_hours number(12,2) := 0.00;        
   v_delta_amount number(12,2) :=0.00;        
   v_delta_current number(12,2) :=0.00;        
   v_delta_current_amount number(12,2) :=0.00;        
   v_rollback_overbudget number(12,2) :=0.00;        
   v_rollback_overbudget_amount number(12,2) :=0.00;        
   v_rollback_current number(12,2) :=0.00;        
   v_rollback_current_amount number(12,2) :=0.00;        
        
   v_ticb_alloc number(12,2) :=0.00;        
   v_subc_alloc number(12,2) :=0.00;        
   v_cumm_ticb_alloc number(12,2) :=0.00;        
   v_cumm_subc_alloc number(12,2) :=0.00;        
   v_rate_code1 inv_ratemaster.rate_code%type;         
   v_rate_code2 inv_ratemaster.rate_code%type;         
   v_rate_code3 inv_ratemaster.rate_code%type;         
   v_rate_code4 inv_ratemaster.rate_code%type;         
   v_rates1 inv_ratemaster.rates%type :=0.00;        
   v_rates2 inv_ratemaster.rates%type :=0.00;        
   v_rates3 inv_ratemaster.rates%type :=0.00;        
   v_rates4 inv_ratemaster.rates%type :=0.00;        
   v_rate_code  inv_ratemaster.rate_code%type;         
   v_rate inv_ratemaster.rates%type :=0.00;        
   v_invoice_no inv_workfile1.invoice_no%type;        
   v_invoicedsofar number(12,0) := 0.00;        
   v_ticbsofar number(12,2) := 0.00;        
   v_subcsofar number(12,2) := 0.00;        
   v_deltasofar number(12,2) := 0.00;        
   v_short_code inv_ratemaster.short_code%type;        
           
   v_loa_found boolean;        
   v_used boolean;        
           
   v_old_rate number(1) := 0;        
           
   v_last_projno projmast.projno%type;        
   v_last_suborder_no inv_workfile1.suborder_no%type;        
   v_inv_no varchar2(6);        
   v_rec inv_workfile1%rowtype;        
        
   v_yearstart timetran.yymm%type := '201804';        
        
   --- Cummulative Manhours Consummed Sofar        
   --cursor c_cumm(p_yymm char) is select a.projno,a.costcode,sum(nvl(a.ticb_hrs,0.00)) as ticbhrs,sum(nvl(a.subc_hrs,0.00)) as subchrs from inv_timetran_tcm a,projmast b where a.yymm <= p_yymm and a.projno = b.projno and nvl(b.tcm_jobs,0.00) > 0.00 group by a.projno,a.costcode order by 1,2;        
   cursor c_cumm(p_yymm char) is select a.projno,a.costcode,sum(nvl(a.ticb_hrs,0.00)) as ticbhrs,sum(nvl(a.subc_hrs,0.00)) as subchrs from inv_timetran_tcm a,projmast b where a.projno = b.projno and nvl(b.excl_billing,0) = 0 and a.yymm >= v_yearstart and a.yymm <= p_yymm group by a.projno,a.costcode order by 1,2;        
        
   --- Cummulative Manhours Consummed in Processing Month        
   --cursor c_curr(p_projno char,p_costcode char,p_yymm char) is select sum(nvl(ticb_hrs,0.00)) as ticbhrs,sum(nvl(subc_hrs,0.00)) as subchrs from inv_timetran_tcm where projno = p_projno and costcode = p_costcode and yymm = p_yymm;        
   cursor c_curr(p_projno char,p_costcode char,p_yymm char) is select sum(nvl(ticb_hrs,0.00)) as ticbhrs,sum(nvl(subc_hrs,0.00)) as subchrs from inv_timetran_tcm where projno = p_projno and costcode = p_costcode and yymm = p_yymm;        
        
   --- Open & Dummy LOA's        
   --- cursor c_loa(p_projno char,p_costcode char) is select suborder_no,loa_no,nvl(budgetted_hours,0.00),nvl(revised_hours,0.00),nvl(ticbconsumed_hours,0.00),nvl(subcconsumed_hours,0.00),nvl(invoiced_hours,0.00)+nvl(delta_hours,0.00) from inv_loa_details where projno = p_projno and costcode = p_costcode and (nvl(budgetted_hours,0.00) > nvl(invoiced_hours,0.00)+nvl(delta_hours,0.00) or suborder_no = 'OVER BUDGET');        
        
   --- select all LOA's        
   cursor c_loa(p_projno char,p_costcode char) is select suborder_no,loa_no,        
   nvl(budgetted_hours,0.00),nvl(revised_hours,0.00),        
   nvl(ticbconsumed_hours,0.00),nvl(subcconsumed_hours,0.00),        
   nvl(invoiced_hours,0.00),nvl(invoiced_opn_amount,0.00)+nvl(invoiced_amount,0.00),        
   nvl(delta_hours,0.00),nvl(delta_amount,0.00),        
   nvl(delta_current,0.00),nvl(delta_current_amount,0.00),        
   nvl(rollback_overbudget,0.00),nvl(rollback_overbudget_amount,0.00),        
   nvl(rollback_current,0.00),nvl(rollback_current_amount,0.00)         
   from inv_loa_details where projno = p_projno and costcode = p_costcode and loa_closed <> 1;        
        
/* not in use        
   --- Get previously invoiced hours from invoice file        
   cursor c_inv(p_projno char,p_costcode char) is select sum(nvl(invoiced_sofar,0.00)) as invsofar from inv_invoice_master where projno = p_projno and costcode = p_costcode;        
*/        
        
   --- Get previously invoiced & consummed hours from loa_details        
   --- Changed on 6th July 2003        
   --- Added (not loa_closed)        
   cursor c_inv(p_projno char,p_costcode char) is select sum(nvl(invoiced_hours,0.00)) as invsofar,sum(nvl(ticbconsumed_hours,0.00)) as ticbsofar,sum(nvl(subcconsumed_hours,0.00)) as subcsofar,sum(nvl(delta_hours,0)+nvl(delta_current,0)) as deltasofar from inv_loa_details where projno = p_projno and costcode = p_costcode and loa_closed <> 1;        
        
begin        
	 if p_prevyear = 0 then        
      --generate_delta_invoices(p_processing_month);        
      open c_cumm(p_processing_month);        
	 else        
      delete from inv_workfile1;        
      delete from inv_workfile2;        
      commit;         
      open c_cumm('201803');        
   end if;           
   v_rates := 0;        
   If c_cumm%ISOPEN Then        
        
      --- loop for entire RAP file        
      Fetch c_cumm into v_projno,v_costcode,v_cumm_ticbhrs,v_cumm_subchrs;        
      Loop        
            
     /* don't consider this        
             
         v_total_ticb := 0.00;        
         v_total_subc := 0.00;        
         v_total_inv  := 0.00;        
        
         --- Extract total manhour consummed sofar on the project        
         select sum(nvl(ticbconsumed_hours,0.00)),sum(nvl(subcconsumed_hours,0.00)),sum(nvl(invoiced_hours,0.00)+nvl(delta_hours,0.00)) into v_total_ticb,v_total_subc,v_total_inv from inv_loa_details where projno = v_projno;        
         
         
         --- if crossed 65,000 then apply rate 3 & 4        
         --- else use rate 1 & 2        
         If v_total_ticb+v_total_subc > 65000 Then        
            v_rates := 1;        
         Else        
            v_rates := 0;        
         End If;        
     */            
        
	       --- disabled v_invoice_no := 'TICB/'||v_projno ||'/'||p_processing_month;        
        
        
/* 			 do not create dummy suborder & loa now. create it at the time of posting        
           
	       --- Check if dummy suborder exist if not then create one        
         declare        
           v_return char(1);        
         begin        
            select null into v_return from inv_suborder_master where projno = v_projno and suborder_no = 'OVER BUDGET';        
         exception        
            when no_data_found then        
                 insert into inv_suborder_master(projno,suborder_no,dates,total_hrs) values(v_projno,'OVER BUDGET',sysdate,0);        
                 insert into inv_loa_master(projno,suborder_no,loa_no,dates,total_hrs) values(v_projno,'OVER BUDGET','OVER BUDGET',sysdate,0);        
         end;        
*/                 
        
         --- loop for one project         
         v_loopprojno := v_projno;        
         select tcmno into v_tcm_no from projmast where projno = v_loopprojno;        
        
        
         while v_projno = v_loopprojno loop        
              v_loopcostcode := v_costcode;        
        
              --- Fetch Position Code & Rates        
        
              v_rates1 := 0.00;          
              v_rates2 := 0.00;                      
              v_rates3 := 0.00;        
              v_rates4 := 0.00;        
                   
              /*        
              v_old_rate := 0;        
   	               
		          begin        
                 select rate_code1,        
                        rate_code2,        
                        rate_code3,        
                        rate_code4 into        
           		          v_rate_code1,        
           		          v_rate_code2,        
           		          v_rate_code3,        
           		          v_rate_code4        
                 from inv_proj_dept_ratemaster         
                 where projno = v_loopprojno and costcode = v_loopcostcode;        
             exception        
               	when no_data_found then        
                 	   begin        
                       	select rate_code1,        
                     	         rate_code2,        
                     	         ratecode3,        
                     	         ratecode4 into        
                               v_rate_code1,        
                               v_rate_code2,        
                               v_rate_code3,        
                               v_rate_code4         
                        from inv_dept_ratemaster         
                        where costcode = v_loopcostcode;         
                     exception        
                   	    when no_data_found then        
                       		   v_rate_code1 := 'Z1';        
                             v_rate_code2 := 'Z2';        
                             v_rate_code3 := 'Z3';        
  	                         v_rate_code4 := 'Z4';        
      	             end;        
       		   end;        
             if v_old_rate = 1 then        
                select nvl(old_rates,0) into v_rates1 from inv_ratemaster where rate_code = v_rate_code1;        
                select nvl(old_rates,0) into v_rates2 from inv_ratemaster where rate_code = v_rate_code2;        
                select nvl(old_rates,0) into v_rates3 from inv_ratemaster where rate_code = v_rate_code3;        
                select nvl(old_rates,0) into v_rates4 from inv_ratemaster where rate_code = v_rate_code4;        
             else        
                select nvl(rates,0) into v_rates1 from inv_ratemaster where rate_code = v_rate_code1;        
                select nvl(rates,0) into v_rates2 from inv_ratemaster where rate_code = v_rate_code2;        
                select nvl(rates,0) into v_rates3 from inv_ratemaster where rate_code = v_rate_code3;        
                select nvl(rates,0) into v_rates4 from inv_ratemaster where rate_code = v_rate_code4;        
             end if;	        
        
             If v_rates = 0  Then        
                v_rate_code := v_rate_code1;        
                v_rate := v_rates1;        
             Else        
                v_rate_code := v_rate_code3;        
                v_rate := v_rates3;        
             End If;        
             */        
        
              /* Not required now        
              --- Fetch current month consummed manhours	        
              open c_curr(v_loopprojno,v_loopcostcode,p_processing_month);        
              If c_curr%ISOPEN Then        
                 loop        
                     Fetch c_curr into v_ticbhrs,v_subchrs;        
                     Exit When c_curr%NOTFOUND;        
                 End Loop;        
                 close c_curr;        
               End If;        
              */        
                      
		          --- Fetch old invoiced hours        
		          v_invoicedsofar := 0.00;        
		          v_subcsofar := 0.00;        
		          v_ticbsofar := 0.00;        
              open c_inv(v_loopprojno,v_loopcostcode);        
              If c_inv%ISOPEN Then        
                 loop        
                     Fetch c_inv into v_invoicedsofar,v_ticbsofar,v_subcsofar,v_deltasofar;        
                     Exit When c_inv%NOTFOUND;        
                 End Loop;        
                 close c_inv;        
              End If;        
                      
              -- Reduce it from TICB's consumed hours        
              -- Don't use        
              -- v_cumm_ticbhrs := v_cumm_ticbhrs - v_invoicedsofar;        
              v_cumm_ticbhrs := v_cumm_ticbhrs - v_ticbsofar;        
              v_cumm_subchrs := v_cumm_subchrs - v_subcsofar;        
        
              v_cumm_ticb_alloc := 0.00;        
              v_cumm_subc_alloc := 0.00;        
        
        
              while v_projno = v_loopprojno and v_costcode = v_loopcostcode loop        
        
                   v_loa_found := false;        
                   --- Fetch LOA's        
        
                   open c_loa(v_loopprojno,v_loopcostcode);        
                   If c_loa%ISOPEN Then        
        
                      loop        
                         -- Fetch c_loa into v_suborder_no,v_loa_no,v_budgetted,        
                         -- v_revised,v_ticbconsumed,v_subcconsumed,v_invoiced,        
                         -- v_delta,v_delta_current,v_invoiced_opn_amount,v_invoiced_amount;        
                         Fetch c_loa into v_suborder_no,v_loa_no,        
                         v_budgetted,v_revised,        
                         v_ticbconsumed,v_subcconsumed,        
                         v_invoiced,v_invoiced_amount,        
                         v_delta_hours,v_delta_amount,        
                         v_delta_current,v_delta_current_amount,        
                         v_rollback_overbudget,v_rollback_overbudget_amount,        
                         v_rollback_current,v_rollback_current_amount;        
                         Exit When c_loa%NOTFOUND;        
        
									          v_rates1 := 0.00;          
                            v_rates2 := 0.00;                      
                            v_rates3 := 0.00;        
                            v_rates4 := 0.00;        
                   
                            v_old_rate := 0;        
   	               
    	                      select nvl(old_rate,0) into v_old_rate         
    	                      from inv_loa_master where         
    	                      projno = v_loopprojno and         
    	                      suborder_no = v_suborder_no and         
    	                      loa_no = v_loa_no;        
    	                      -- If not billing for previous year hours spent then         
    	                      -- bill with current year rates        
    	                      /*       
    	                      Temp removed       
    	                      if p_prevyear = 0 then        
    	                      	 v_old_rate := 0;        
    	                      else        
    	                      	 v_old_rate := 1;        
    	                      end if;        
    	                      */       
    	                      --dbms_output.put_line('P: '||v_loopprojno||' C: '||v_loopcostcode||' S: ' ||v_suborder_no||' L: '||v_loa_no||' R: '||v_old_rate);        
                   	        begin        
                               select rate_code1,        
                                      rate_code2,        
                                      rate_code3,        
                                      rate_code4 into        
           		                        v_rate_code1,        
           		                        v_rate_code2,        
           		                        v_rate_code3,        
           		                        v_rate_code4        
                               from inv_proj_dept_ratemaster         
                               where projno = v_loopprojno and costcode = v_loopcostcode;        
                            exception        
             	                 when no_data_found then        
                 	                  begin        
                     	                 select rate_code1,        
                     	                        rate_code2,        
                     	                        rate_code3,        
                     	                        rate_code4 into        
                                              v_rate_code1,        
                                              v_rate_code2,        
                                              v_rate_code3,        
                                              v_rate_code4         
                                       from inv_dept_ratemaster         
                                       where costcode = v_loopcostcode;         
                                    exception        
                   	                   when no_data_found then        
                       		                  v_rate_code1 := 'Z1';        
                                            v_rate_code2 := 'Z2';        
                                            v_rate_code3 := 'Z3';        
  	                                        v_rate_code4 := 'Z4';        
      	                            end;        
       		                  end;        
                            if v_old_rate = 1 then        
                               select nvl(old_rates,0) into v_rates1 from inv_ratemaster where rate_code = v_rate_code1;        
                               select nvl(old_rates,0) into v_rates2 from inv_ratemaster where rate_code = v_rate_code2;        
                               select nvl(old_rates,0) into v_rates3 from inv_ratemaster where rate_code = v_rate_code3;        
                               select nvl(old_rates,0) into v_rates4 from inv_ratemaster where rate_code = v_rate_code4;        
                            else        
                            	 if v_old_rate = 2 then        
                                  select nvl(old_rates_2000,0) into v_rates1 from inv_ratemaster where rate_code = v_rate_code1;        
                                  select nvl(old_rates_2000,0) into v_rates2 from inv_ratemaster where rate_code = v_rate_code2;        
                                  select nvl(old_rates_2000,0) into v_rates3 from inv_ratemaster where rate_code = v_rate_code3;        
                                  select nvl(old_rates_2000,0) into v_rates4 from inv_ratemaster where rate_code = v_rate_code4;        
                            	 else	        
                                  select nvl(rates,0) into v_rates1 from inv_ratemaster where rate_code = v_rate_code1;        
                                  select nvl(rates,0) into v_rates2 from inv_ratemaster where rate_code = v_rate_code2;        
                                  select nvl(rates,0) into v_rates3 from inv_ratemaster where rate_code = v_rate_code3;        
                                  select nvl(rates,0) into v_rates4 from inv_ratemaster where rate_code = v_rate_code4;        
                               end if;           
                            end if;	        
        
  	                        If v_rates = 0  Then        
                               v_rate_code := v_rate_code1;        
                               v_rate := v_rates1;        
                            Else        
                               v_rate_code := v_rate_code3;        
                               v_rate := v_rates3;        
                            End If;        
        
        
                         --- If not dummy LOA        
                         --IF v_loa_no <> 'OVER BUDGET' Then        
        
                         v_loa_found := true;        
                                    
                         --- if balance to invoiced        
                         --- if (v_cumm_ticbhrs-v_cumm_ticb_alloc)+(v_cumm_subchrs-v_cumm_subc_alloc) > 0 then        
        
                         --- if balance to invoiced and balance budget        
                         v_used := false;        
                                 
                         if ((v_cumm_ticbhrs-v_cumm_ticb_alloc)+(v_cumm_subchrs-v_cumm_subc_alloc) > 0) and (floor(v_budgetted-(v_ticbconsumed+v_subcconsumed+v_delta_hours+v_delta_current-v_rollback_overbudget-v_rollback_current)) > 0) then        
                         	          
                         	  v_used := true;        
        
        
                            --- if balance budget is less than balance consummed to allocate (Both TICB & SUBC)        
                            IF v_budgetted-(v_ticbconsumed+v_subcconsumed+v_delta_hours+v_delta_current-v_rollback_overbudget-v_rollback_current) < (v_cumm_ticbhrs-v_cumm_ticb_alloc)+(v_cumm_subchrs-v_cumm_subc_alloc) Then        
                               -- if balance budget is less than balance consummed to allocate (Only TICB)        
                               IF floor(v_budgetted-(v_ticbconsumed+v_subcconsumed+v_delta_hours+v_delta_current-v_rollback_overbudget-v_rollback_current)) < (v_cumm_ticbhrs-v_cumm_ticb_alloc) Then           
                               	  -- allocated only ticb hours with balance budget        
                               	  -- invoice available balance budget with first rate        
                                  --insert into inv_workfile1(projno,suborder_no,loa_no,costcode,budget,revised,ticb_sofar,subc_sofar,        
                                  --invoiced_sofar,ticb_current,subc_current,invoiced_current,rate_code,rate,overbudget,yymm,invoice_no,tcm_no,short_code,delta_sofar,delta_current,invoiced_sofar_amount)         
                                  insert into inv_workfile1(projno,suborder_no,loa_no,costcode,budget,        
                                  revised,ticb_sofar,subc_sofar,invoiced_sofar,ticb_current,subc_current,        
                                  invoiced_current,rate_code,rate,overbudget,yymm,invoice_no,tcm_no,        
                                  short_code,delta_inv,old_invoice_no,delta_sofar,delta_current,        
                                  invoiced_sofar_amount,delta_current_amount,rollback_sofar,rollback_sofar_amount,        
                                  rollback_current,rollback_current_amount,additional)         
                                  values(v_loopprojno,v_suborder_no,v_loa_no,v_loopcostcode,v_budgetted,        
                                  v_revised,v_ticbconsumed,v_subcconsumed,v_invoiced,floor(v_budgetted-(v_ticbconsumed+v_subcconsumed+v_delta_hours+v_delta_current-v_rollback_overbudget-v_rollback_current)),0.00,        
                                  floor(v_budgetted-(v_ticbconsumed+v_subcconsumed+v_delta_hours+v_delta_current-v_rollback_overbudget-v_rollback_current)),v_rate_code,v_rate,0,p_processing_month,v_invoice_no,v_tcm_no,        
                                  v_short_code,0,null,v_delta_hours,v_delta_current,        
                                  v_invoiced_amount,v_delta_current_amount,v_rollback_overbudget,v_rollback_overbudget_amount,        
                                  v_rollback_current,v_rollback_current_amount,0);        
                                  v_cumm_ticb_alloc := v_cumm_ticb_alloc + (floor(v_budgetted-(v_ticbconsumed+v_subcconsumed+v_delta_hours+v_delta_current-v_rollback_overbudget-v_rollback_current)));        
                                  --values(v_loopprojno,v_suborder_no,v_loa_no,v_loopcostcode,v_budgetted,v_revised,v_ticbconsumed,v_subcconsumed,        
                                  --v_invoiced,v_budgetted-(v_ticbconsumed+v_subcconsumed+v_delta_hours+v_delta_current),0.00,v_budgetted-(v_ticbconsumed+v_subcconsumed+v_delta_hours+v_delta_current),v_rate_code,v_rate,0,p_processing_month,v_invoice_no,v_tcm_no,v_short_code,v_delta_hours,v_delta_current,v_invoiced_amount);        
                                  --v_cumm_ticb_alloc := v_cumm_ticb_alloc + (v_budgetted-(v_ticbconsumed+v_subcconsumed+v_delta_hours+v_delta_current));        
                               Else        
                               	  --- if only ticb's balance consummed is less than balance budget        
                               	  --- allocate full ticb hours & balance budget with subc hours        
                               	  --- invoice only ticb hours(full) with first rate	        
                                  --insert into inv_workfile1(projno,suborder_no,loa_no,costcode,budget,revised,ticb_sofar,subc_sofar,        
                                  --invoiced_sofar,ticb_current,subc_current,invoiced_current,rate_code,rate,overbudget,yymm,invoice_no,tcm_no,short_code,delta_sofar,delta_current,invoiced_sofar_amount)         
                                  insert into inv_workfile1(projno,suborder_no,loa_no,costcode,budget,        
                                  revised,ticb_sofar,subc_sofar,invoiced_sofar,ticb_current,subc_current,        
                                  invoiced_current,rate_code,rate,overbudget,yymm,invoice_no,tcm_no,        
                                  short_code,delta_inv,old_invoice_no,delta_sofar,delta_current,        
                                  invoiced_sofar_amount,delta_current_amount,rollback_sofar,rollback_sofar_amount,        
                                  rollback_current,rollback_current_amount,additional)         
                                  values(v_loopprojno,v_suborder_no,v_loa_no,v_loopcostcode,v_budgetted,        
                                  v_revised,v_ticbconsumed,v_subcconsumed,v_invoiced,v_cumm_ticbhrs-v_cumm_ticb_alloc,(floor(v_budgetted-(v_ticbconsumed+v_subcconsumed+v_delta_hours+v_delta_current-v_rollback_overbudget-v_rollback_current)))-(v_cumm_ticbhrs-v_cumm_ticb_alloc),        
                                  v_cumm_ticbhrs-v_cumm_ticb_alloc,v_rate_code,v_rate,0,p_processing_month,v_invoice_no,v_tcm_no,        
                                  v_short_code,0,null,v_delta_hours,v_delta_current,        
                                  v_invoiced_amount,v_delta_current_amount,v_rollback_overbudget,v_rollback_overbudget_amount,        
                                  v_rollback_current,v_rollback_current_amount,0);        
                                  --values(v_loopprojno,v_suborder_no,v_loa_no,v_loopcostcode,v_budgetted,v_revised,v_ticbconsumed,v_subcconsumed,        
                                  --v_invoiced,v_cumm_ticbhrs-v_cumm_ticb_alloc,(v_budgetted-(v_ticbconsumed+v_subcconsumed+v_delta_hours+v_delta_current))-(v_cumm_ticbhrs-v_cumm_ticb_alloc),v_cumm_ticbhrs-v_cumm_ticb_alloc,v_rate_code,v_rate,0,p_processing_month,v_invoice_no,v_tcm_no,v_short_code,v_delta_hours,v_delta_current,v_invoiced_amount);        
                                  v_cumm_ticb_alloc := v_cumm_ticb_alloc + floor((v_cumm_ticbhrs-v_cumm_ticb_alloc));        
                                  v_cumm_subc_alloc := v_cumm_subc_alloc + ((floor(v_budgetted-(v_ticbconsumed+v_subcconsumed+v_delta_hours+v_delta_current-v_rollback_overbudget-v_rollback_current)))-(v_cumm_ticbhrs-v_cumm_ticb_alloc));        
                               End IF;        
                            Else           
                               --- if balance budget is more than ticb's and subc's balance consummed    	  	        
                               --- allocate full ticb's & subc's hours	        
                               --- invoice only ticb hours(full) with first rate         
                               --insert into inv_workfile1(projno,suborder_no,loa_no,costcode,budget,revised,ticb_sofar,subc_sofar,        
                               --invoiced_sofar,ticb_current,subc_current,invoiced_current,rate_code,rate,overbudget,yymm,invoice_no,tcm_no,short_code,delta_sofar,delta_current,invoiced_sofar_amount)         
                               insert into inv_workfile1(projno,suborder_no,loa_no,costcode,budget,        
                               revised,ticb_sofar,subc_sofar,invoiced_sofar,ticb_current,subc_current,        
                               invoiced_current,rate_code,rate,overbudget,yymm,invoice_no,tcm_no,        
                               short_code,delta_inv,old_invoice_no,delta_sofar,delta_current,        
                               invoiced_sofar_amount,delta_current_amount,rollback_sofar,rollback_sofar_amount,        
                               rollback_current,rollback_current_amount,additional)         
                               values(v_loopprojno,v_suborder_no,v_loa_no,v_loopcostcode,v_budgetted,        
                               v_revised,v_ticbconsumed,v_subcconsumed,v_invoiced,floor(v_cumm_ticbhrs-v_cumm_ticb_alloc),floor(v_cumm_subchrs-v_cumm_subc_alloc),        
                               floor(v_cumm_ticbhrs-v_cumm_ticb_alloc),v_rate_code,v_rate,0,p_processing_month,v_invoice_no,v_tcm_no,        
                               v_short_code,0,null,v_delta_hours,v_delta_current,        
                               v_invoiced_amount,v_delta_current_amount,v_rollback_overbudget,v_rollback_overbudget_amount,        
                               v_rollback_current,v_rollback_current_amount,0);        
                               --values(v_loopprojno,v_suborder_no,v_loa_no,v_loopcostcode,v_budgetted,v_revised,v_ticbconsumed,v_subcconsumed,        
                               --v_invoiced,v_cumm_ticbhrs-v_cumm_ticb_alloc,v_cumm_subchrs-v_cumm_subc_alloc,v_cumm_ticbhrs-v_cumm_ticb_alloc,v_rate_code,v_rate,0,p_processing_month,v_invoice_no,v_tcm_no,v_short_code,v_delta_hours,v_delta_current,v_invoiced_amount);        
                               v_cumm_ticb_alloc := v_cumm_ticb_alloc + floor((v_cumm_ticbhrs-v_cumm_ticb_alloc));        
                               v_cumm_subc_alloc := v_cumm_subc_alloc + floor((v_cumm_subchrs-v_cumm_subc_alloc));        
                            End IF;           
                        end if;               
                     --Else        
                     /* Disabled - do not add old dummy loa      	        
	                      --- Insert old dummy LOA into workfile        
                        insert into inv_workfile1(projno,suborder_no,loa_no,costcode,budget,revised,ticb_sofar,subc_sofar,        
                        invoiced_sofar,ticb_current,subc_current,invoiced_current,rate_code,rate,overbudget,yymm,invoice_no,tcm_no)         
                        values(v_loopprojno,v_suborder_no,v_loa_no,v_loopcostcode,v_budgetted,v_revised,v_ticbconsumed,v_subcconsumed,        
                        v_invoiced,0.00,0.00,0.00,null,0.00,0,p_processing_month,v_invoice_no,v_tcm_no);        
                        */        
                      --   null;           
                      --End If;        
                      End Loop;        
                      close c_loa;        
                   End If;        
        
                   --- no pending LOA's        
                   --- and if TICB's & SUBC's manhours is still balance and atleast one LOA was there        
                   --If (v_cumm_ticbhrs-v_cumm_ticb_alloc)+(v_cumm_subchrs-v_cumm_subc_alloc) > 0.00  and v_loa_found Then        
        
                             
                   --- no pending LOA's        
                   --- and if TICB's manhours is still balance and atleast one LOA was there        
                   --- and if TICB's manhours is still balance and atleast one LOA was there        
                   If (v_cumm_ticbhrs-v_cumm_ticb_alloc) > 0.00  and v_loa_found Then        
                      If v_rates = 0  Then        
                         v_rate_code := v_rate_code2;        
                         v_rate := v_rates2;        
                      Else        
                         v_rate_code := v_rate_code4;        
                         v_rate := v_rates4;        
                      End If;        
        
											/* Disabled - do not allocated over budgtted manhours against        
											   dummy loa        
                      --- Check if dummy LOA is exist? if not then create one and insert into workfile        
                      declare        
                         v_return char(1);        
                      begin        
                            select null into v_return from inv_loa_details where projno = v_loopprojno and costcode = v_loopcostcode and suborder_no = 'OVER BUDGET';        
                      exception        
	                          when no_data_found then        
        
  			 											 --- do not create loa details now. create it at the time of posting        
                               --- insert into inv_loa_details(projno,suborder_no,loa_no,costcode,budgetted_hours,revised_hours,ticbconsumed_hours,subcconsumed_hours,invoiced_hours)        
                               --- values(v_loopprojno,'OVER BUDGET','OVER BUDGET',v_loopcostcode,0.00,0.00,0.00,0.00,0.00);        
                                       
        
                               insert into inv_workfile1(projno,suborder_no,loa_no,costcode,budget,revised,ticb_sofar,subc_sofar,        
                               invoiced_sofar,ticb_current,subc_current,invoiced_current,rate_code,rate,overbudget,yymm,invoice_no,tcm_no)         
                               values(v_loopprojno,'OVER BUDGET','OVER BUDGET',v_loopcostcode,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,null,0.00,1,p_processing_month,v_invoice_no,v_tcm_no);        
                      end;        
        
                      --- allocate over budget manhours againt dummy LOA        
		                  update inv_workfile1 set ticb_current = ticb_current + floor((v_cumm_ticbhrs-v_cumm_ticb_alloc)),        
                             subc_current = subc_current + floor((v_cumm_subchrs-v_cumm_subc_alloc)),        
                             invoiced_current = invoiced_current + floor((v_cumm_ticbhrs-v_cumm_ticb_alloc)),        
                             rate_code = v_rate_code,        
                             rate = v_rate,        
                             overbudget = 1,        
                             yymm = p_processing_month,        
                             invoice_no = v_invoice_no         
                             where projno = v_loopprojno and costcode = v_loopcostcode and suborder_no = 'OVER BUDGET'         
                             and loa_no = 'OVER BUDGET';        
                      */               
                                     
                      /* not in use                
                      v_cumm_ticb_alloc := v_cumm_ticb_alloc + floor((v_cumm_ticbhrs - v_cumm_ticb_alloc));        
                      v_cumm_subc_alloc := v_cumm_subc_alloc + floor((v_cumm_subchrs - v_cumm_subc_alloc));        
                      */        
                              
											/* New - allocated over budgtted manhours against last loa. */        
											if v_used then        
                         --insert into inv_workfile1(projno,suborder_no,loa_no,costcode,budget,revised,ticb_sofar,subc_sofar,        
                         --invoiced_sofar,ticb_current,subc_current,invoiced_current,rate_code,rate,overbudget,yymm,invoice_no,tcm_no,short_code,delta_sofar,delta_current,invoiced_sofar_amount)         
                         /*         
                         Over Budget Billing Disabled on 22nd Nov 2004        
                                
                         insert into inv_workfile1(projno,suborder_no,loa_no,costcode,budget,        
                         revised,ticb_sofar,subc_sofar,invoiced_sofar,ticb_current,subc_current,        
                         invoiced_current,rate_code,rate,overbudget,yymm,invoice_no,tcm_no,        
                         short_code,delta_inv,old_invoice_no,delta_sofar,delta_current,        
                         invoiced_sofar_amount,delta_current_amount,rollback_sofar,rollback_sofar_amount,        
                         rollback_current,rollback_current_amount,additional)         
                         values(v_loopprojno,v_suborder_no,v_loa_no,v_loopcostcode,0,        
                         0,0,0,0,(v_cumm_ticbhrs-v_cumm_ticb_alloc),(v_cumm_subchrs-v_cumm_subc_alloc),        
                         (v_cumm_ticbhrs-v_cumm_ticb_alloc),v_rate_code,v_rate,1,p_processing_month,v_invoice_no,v_tcm_no,        
                         v_short_code,0,null,0,0,        
                         0,0,0,0,        
                         0,0,0);        
                         --values(v_loopprojno,v_suborder_no,v_loa_no,v_loopcostcode,0,0,0,0,0,        
                         --(v_cumm_ticbhrs-v_cumm_ticb_alloc),(v_cumm_subchrs-v_cumm_subc_alloc),(v_cumm_ticbhrs-v_cumm_ticb_alloc),        
                         --v_rate_code,v_rate,1,p_processing_month,v_invoice_no,v_tcm_no,v_short_code,0,0,0);        
                                 
                         */        
                         null;        
                      else           
                         --insert into inv_workfile1(projno,suborder_no,loa_no,costcode,budget,revised,ticb_sofar,subc_sofar,        
                         --invoiced_sofar,ticb_current,subc_current,invoiced_current,rate_code,rate,overbudget,yymm,invoice_no,tcm_no,short_code,delta_sofar,delta_current,invoiced_sofar_amount)         
                         /*         
                         Over Budget Billing Disabled on 22nd Nov 2004        
                                
                         insert into inv_workfile1(projno,suborder_no,loa_no,costcode,budget,        
                         revised,ticb_sofar,subc_sofar,invoiced_sofar,ticb_current,subc_current,        
                         invoiced_current,rate_code,rate,overbudget,yymm,invoice_no,tcm_no,        
                         short_code,delta_inv,old_invoice_no,delta_sofar,delta_current,        
                         invoiced_sofar_amount,delta_current_amount,rollback_sofar,rollback_sofar_amount,        
                         rollback_current,rollback_current_amount,additional)         
                         values(v_loopprojno,v_suborder_no,v_loa_no,v_loopcostcode,v_budgetted,        
                         v_revised,v_ticbconsumed,v_subcconsumed,v_invoiced,floor(v_cumm_ticbhrs-v_cumm_ticb_alloc),floor(v_cumm_subchrs-v_cumm_subc_alloc),        
                         floor(v_cumm_ticbhrs-v_cumm_ticb_alloc),v_rate_code,v_rate,1,p_processing_month,v_invoice_no,v_tcm_no,        
                         v_short_code,0,null,v_delta_hours,v_delta_current,        
                         v_invoiced_amount,v_delta_current_amount,v_rollback_overbudget,v_rollback_overbudget_amount,        
                         v_rollback_current,v_rollback_current_amount,0);        
                         --values(v_loopprojno,v_suborder_no,v_loa_no,v_loopcostcode,v_budgetted,v_revised,v_ticbconsumed,v_subcconsumed,v_invoiced,        
                         --(v_cumm_ticbhrs-v_cumm_ticb_alloc),(v_cumm_subchrs-v_cumm_subc_alloc),(v_cumm_ticbhrs-v_cumm_ticb_alloc),        
                         --v_rate_code,v_rate,1,p_processing_month,v_invoice_no,v_tcm_no,v_short_code,v_delta_hours,v_delta_current,v_invoiced_amount);        
                                
                         */        
                         null;        
                      end if;           
                   End If;        
		               /* not in use         
		               v_total_ticb := v_total_ticb + floor(v_cumm_ticb_alloc);        
                   v_total_subc := v_total_subc + floor(v_cumm_subc_alloc);        
                   v_total_inv  := v_total_inv + floor(v_cumm_ticb_alloc);        
                   */        
                   Fetch c_cumm into v_projno,v_costcode,v_cumm_ticbhrs,v_cumm_subchrs;        
                   Exit When c_cumm%NOTFOUND;        
              End Loop;        
              Exit When c_cumm%NOTFOUND;        
          End Loop;           
          Exit When c_cumm%NOTFOUND;        
      End Loop;        
      close c_cumm;        
   End If;        
   -- delete all un-used loa from workfile                                 
-- Modified on 11-02-10    
   -- delete from inv_workfile1 where nvl(ticb_current,0)+nvl(subc_current,0)+nvl(invoiced_current,0) = 0;                                 
    delete from inv_workfile1 where projno in (select distinct projno from     
((select projno,sum(nvl(ticb_current,0)+nvl(subc_current,0)+nvl(invoiced_current,0))     
from inv_workfile1 having sum(nvl(ticb_current,0)+nvl(subc_current,0)+nvl(invoiced_current,0)) = 0 group by projno)));                                 
-- Modification Complete    
   -- update invoice nos.        
   --update inv_workfile1 set invoice_no = ltrim(rtrim(tcm_no)) || '-' || ltrim(rtrim(suborder_no)) || '-' || yymm where nvl(delta_inv,0) = 0 ;        
   update inv_workfile1 set short_code = (select short_code from inv_ratemaster where rate_code = inv_workfile1.rate_code) where nvl(delta_inv,0) = 0;        
   update inv_workfile1 set eou_job = (select nvl(eou_job,0) from projmast where inv_workfile1.projno = projmast.projno);        
--   update inv_workfile1 set eou_job = (select decode(co,'E',0,1) from projmast where inv_workfile1.projno = projmast.projno);        
   v_last_projno := ' ';        
   v_last_suborder_no := ' ';        
   v_inv_no := ' ';        
   declare        
   	  cursor v_c1 is select * from inv_workfile1 where nvl(delta_inv,0) = 0 and nvl(eou_job,0) = 0  order by projno,suborder_no for update;        
   	  cursor v_c2 is select * from inv_workfile1 where nvl(delta_inv,0) = 0 and nvl(eou_job,0) = 1  order by projno,suborder_no for update;        
   begin	        
   open v_c1;        
   loop        
      fetch v_c1 into v_rec;        
      exit when v_c1%NOTFOUND;        
      if v_rec.projno <> v_last_projno then        
   	   	  v_last_projno := v_rec.projno;        
   	   	  v_last_suborder_no := v_rec.suborder_no;        
   	      begin        
   	   	     select last_inv into v_inv_no from inv_invoice_nos where division = 'BO';        
   	   	     v_inv_no := LPAD(RTRIM(LTRIM(TO_CHAR(TO_NUMBER(v_inv_no)+1))),6,'0');        
   	   	     update inv_invoice_nos set last_inv = v_inv_no where division = 'BO';        
   	      exception        
   	      	 when no_data_found then        
   	      	      v_inv_no := '000001';        
   	      	      insert into inv_invoice_nos(last_inv,last_delta_inv,division) values(v_inv_no,'100000','BO');        
   	      	 when others then        
                  dbms_output.put_line('ERROR : 2 '||SQLERRM);        
                  rollback;                   	        
                  raise;        
   	      end;        
   	   end if;        
   	   if v_rec.suborder_no <> v_last_suborder_no then        
   	   	  v_last_suborder_no := v_rec.suborder_no;        
   	      v_inv_no := LPAD(RTRIM(LTRIM(TO_CHAR(TO_NUMBER(v_inv_no)+1))),6,'0');        
   	      update inv_invoice_nos set last_inv = v_inv_no where division = 'BO';        
   	   end if;	        
   	   update inv_workfile1 set invoice_no = v_inv_no where current of v_c1;        
   end loop;        
   close v_c1;        
   open v_c2;        
   loop        
      fetch v_c2 into v_rec;        
      exit when v_c2%NOTFOUND;        
      if v_rec.projno <> v_last_projno then        
   	   	  v_last_projno := v_rec.projno;        
   	   	  v_last_suborder_no := v_rec.suborder_no;        
   	      begin        
   	   	     select last_inv into v_inv_no from inv_invoice_nos where division = 'EO';        
   	   	     v_inv_no := LPAD(RTRIM(LTRIM(TO_CHAR(TO_NUMBER(v_inv_no)+1))),6,'0');        
   	   	     update inv_invoice_nos set last_inv = v_inv_no where division = 'EO';        
   	      exception        
   	      	 when no_data_found then        
   	      	      v_inv_no := '500001';        
   	      	      insert into inv_invoice_nos(last_inv,last_delta_inv,division) values(v_inv_no,'200000','EO');        
   	      	 when others then        
                  dbms_output.put_line('ERROR : 2 '||SQLERRM);        
                  rollback;                   	        
                  raise;        
   	      end;        
   	   end if;        
   	   if v_rec.suborder_no <> v_last_suborder_no then        
   	   	  v_last_suborder_no := v_rec.suborder_no;        
   	      v_inv_no := LPAD(RTRIM(LTRIM(TO_CHAR(TO_NUMBER(v_inv_no)+1))),6,'0');        
   	      update inv_invoice_nos set last_inv = v_inv_no where division = 'EO';        
   	   end if;	        
   	   update inv_workfile1 set invoice_no = v_inv_no where current of v_c2;        
   end loop;        
   close v_c2;        
   end;        
   declare        
      cursor c1 is select * from inv_loa_details order by projno,suborder_no,loa_no,costcode;        
      v_return number(4);        
      v_yymm char(6);        
      v_invoice_no char(30);        
      v_tcm_no char(6);        
   begin        
      for loa in c1 loop        
         begin        
            select count(*) into v_return from inv_workfile1 where projno = loa.projno and suborder_no = loa.suborder_no and loa_no = loa.loa_no and costcode = loa.costcode and nvl(delta_inv,0) = 0;        
            if v_return = 0 then        
               begin        
                  select distinct yymm,invoice_no,tcm_no into v_yymm,v_invoice_no,v_tcm_no from inv_workfile1 where projno = loa.projno and suborder_no = loa.suborder_no and nvl(delta_inv,0) = 0;        
                  --insert into inv_workfile1(projno,suborder_no,loa_no,costcode,budget,revised,ticb_sofar,subc_sofar,invoiced_sofar,ticb_current,subc_current,invoiced_current,rate_code,overbudget,rate,yymm,invoice_no,allocated,tcm_no,short_code,delta_inv,old_invoice_no,delta_sofar,delta_current,invoiced_sofar_amount)         
                  insert into inv_workfile1(projno,suborder_no,loa_no,costcode,budget,        
                  revised,ticb_sofar,subc_sofar,invoiced_sofar,ticb_current,subc_current,        
                  invoiced_current,rate_code,rate,overbudget,yymm,invoice_no,tcm_no,        
                  short_code,delta_inv,old_invoice_no,delta_sofar,delta_current,        
                  invoiced_sofar_amount,delta_current_amount,rollback_sofar,rollback_sofar_amount,        
                  rollback_current,rollback_current_amount,additional)         
                  values(loa.projno,loa.suborder_no,loa.loa_no,loa.costcode,loa.budgetted_hours,        
                  loa.revised_hours,loa.ticbconsumed_hours,loa.subcconsumed_hours,loa.invoiced_hours,0,0,        
                  0,null,0,0,v_yymm,v_invoice_no,v_tcm_no,        
                  null,0,null,loa.delta_hours,loa.delta_current,        
                  loa.invoiced_amount+loa.invoiced_opn_amount,loa.delta_current_amount,loa.rollback_overbudget,loa.rollback_overbudget_amount,        
                  loa.rollback_current,loa.rollback_current_amount,1);        
                  --values(loa.projno,loa.suborder_no,loa.loa_no,loa.costcode,loa.budgetted_hours,loa.revised_hours,loa.ticbconsumed_hours,loa.subcconsumed_hours,loa.invoiced_hours,0,0,0,null,0,0,v_yymm,v_invoice_no,0,v_tcm_no,null,0,null,loa.delta_hours,loa.delta_current,loa.invoiced_amount+loa.invoiced_opn_amount);        
               exception        
               	  when no_data_found then        
               	       null;        
               	  when others then        
                       dbms_output.put_line('ERROR : '||SQLERRM);        
                       rollback;                   	        
                       raise;        
               end;       
            end if;          
         end;        
      end loop;        
   end;        
   commit;        
exception        
   when others then        
        dbms_output.put_line('ERROR : '||SQLERRM);        
        rollback;                    
        raise;       	        
END        
;

/

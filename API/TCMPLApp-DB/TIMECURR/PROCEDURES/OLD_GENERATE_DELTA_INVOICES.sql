--------------------------------------------------------
--  DDL for Procedure OLD_GENERATE_DELTA_INVOICES
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "TIMECURR"."OLD_GENERATE_DELTA_INVOICES" (p_processing_month in timetran.yymm%type) IS
   
   v_tcm_no projmast.tcmno%type;
   v_rates number(1) :=0;
   v_return number(4):=0;

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
   v_short_code inv_ratemaster.short_code%type;
       
   v_balance_to_invoice number(12,2) := 0.00;
   v_invoice_now number(12,2) := 0.00;
   
   v_budgetted_hours number(12,2) := 0.00;
   v_revised_hours number(12,2) := 0.00;
   v_ticbconsumed_hours number(12,2) := 0.00;
   v_subcconsumed_hours number(12,2) := 0.00;
   v_invoiced_hours number(12,2) := 0.00;
   v_invoiced_amount number(12,2) := 0.00;
   v_invoiced_opn_amount number(12,2) := 0.00;
   v_delta_hours number(12,2) := 0.00;
   v_delta_amount number(12,2) := 0.00;
   v_delta_current number(12,2) := 0.00;
   v_delta_current_amount number(12,2) := 0.00;
   v_rollback_overbudget number(12,2) := 0.00;
   v_rollback_overbudget_amount number(12,2) := 0.00;
   v_rollback_current number(12,2) := 0.00;
   v_rollback_current_amount number(12,2) := 0.00;
   v_invyymm inv_invoice_master.yymm%type;

   v_last_projno projmast.projno%type;
   v_inv_no varchar2(6);
   --- Get balance overbugetted invoices
   cursor c_inv_delta is select inv_invoice_master.* from inv_invoice_master,projmast  where inv_invoice_master.projno = projmast.projno and nvl(projmast.excl_delta_billing,0) = 0 and inv_invoice_master.overbudget > 0 and nvl(inv_invoice_master.invoiced_current,0)-(nvl(inv_invoice_master.rollback_overbudget,0)+nvl(inv_invoice_master.rollback_current,0)) > 0 and nvl(inv_invoice_master.delta_inv,0) = 0 order by inv_invoice_master.projno,inv_invoice_master.costcode,inv_invoice_master.suborder_no,inv_invoice_master.loa_no for update;
   
   --- Get balance loa's
   cursor c_loa_update(p_projno char,p_costcode char) is select * from inv_loa_details where projno = p_projno and costcode = p_costcode and loa_closed <> 1 and nvl(budgetted_hours,0)-(nvl(ticbconsumed_hours,0)+nvl(subcconsumed_hours,0)+nvl(delta_hours,0)+nvl(delta_current,0)) > 0 for update;

begin
	 delete from inv_workfile1;
	 update inv_invoice_master set rollback_current = 0;
	 update inv_loa_details set delta_current = 0,delta_current_amount = 0,rollback_current = 0,rollback_current_amount = 0;
	 commit;
	 For invoices In c_inv_delta Loop
	 	   v_balance_to_invoice := nvl(invoices.invoiced_current,0.00)-(nvl(invoices.rollback_overbudget,0.00)+nvl(invoices.rollback_current,0.00));
	 	   v_invyymm := invoices.yymm;
	 	   For loas In c_loa_update(invoices.projno,invoices.costcode) Loop
           --- Fetch Position Code & Rates
           v_rates1 := 0.00;  
           v_rates2 := 0.00;              
           v_rates3 := 0.00;
           v_rates4 := 0.00;
   	       
   	       declare
  	       	  v_old_rate number(1);
    	     begin
      	      select nvl(old_rate,0) into v_old_rate from inv_loa_master where projno = loas.projno and suborder_no = loas.suborder_no and loa_no = loas.loa_no;
        	    if v_old_rate = 1 then
					       begin
               		  select a.rate_code1,nvl(b.old_rates,0.00) as rates1,
               		         a.rate_code2,nvl(c.old_rates,0.00) as rates2,
               		         a.rate_code3,nvl(d.old_rates,0.00) as rates3,
               		         a.rate_code4,nvl(e.old_rates,0.00) as rates3 into
           				         v_rate_code1,v_rates1,
           				         v_rate_code2,v_rates2,
           				         v_rate_code3,v_rates3,
           				         v_rate_code4,v_rates4 
                	         from inv_proj_dept_ratemaster a,
                	              inv_ratemaster b,
                	              inv_ratemaster c,
                	              inv_ratemaster d,
                	              inv_ratemaster e 
                	         where a.projno = loas.projno and a.costcode = loas.costcode and 
                	               a.rate_code1 = b.rate_code and 
                	               a.rate_code2 = c.rate_code and 
                	               a.rate_code3 = d.rate_code and 
                	               a.rate_code4 = e.rate_code; 
              	 exception
                  	when no_data_found then
                     		begin
                       	select a.rate_code1,nvl(b.old_rates,0.00) as rates1,a.rate_code2,nvl(c.old_rates,0.00) as rates2,a.ratecode3,nvl(d.old_rates,0.00) as rates3,a.ratecode4,nvl(e.old_rates,0.00) as rates3 into
                        v_rate_code1,v_rates1,v_rate_code2,v_rates2,v_rate_code3,v_rates3,v_rate_code4,v_rates4 
                        from inv_dept_ratemaster a,inv_ratemaster b,inv_ratemaster c,inv_ratemaster d,inv_ratemaster e where a.costcode = loas.costcode 
                        and a.rate_code1 = b.rate_code and a.rate_code2 = c.rate_code and a.ratecode3 = d.rate_code and a.ratecode4 = e.rate_code; 
                    exception
                    	  when no_data_found then
                        		v_rate_code1 := 'Z1';
                            select nvl(old_rates,0) into v_rates1 from inv_ratemaster where rate_code = v_rate_code1;
                            v_rate_code2 := 'Z2';
                            select nvl(old_rates,0) into v_rates2 from inv_ratemaster where rate_code = v_rate_code2;
                            v_rate_code3 := 'Z3';
	                          select nvl(old_rates,0) into v_rates3 from inv_ratemaster where rate_code = v_rate_code3;
  	                        v_rate_code4 := 'Z4';
  		                      select nvl(old_rates,0) into v_rates4 from inv_ratemaster where rate_code = v_rate_code4;
      	           	end;
       					 end;
	        	  end if;	
           end;   
           if v_invyymm < '200104' then
              begin
                 select a.rate_code1,nvl(b.old_rates,0.00) as rates1,a.rate_code2,nvl(c.old_rates,0.00) as rates2,a.rate_code3,nvl(d.old_rates,0.00) as rates3,a.rate_code4,nvl(e.old_rates,0.00) as rates3 into
                 v_rate_code1,v_rates1,v_rate_code2,v_rates2,v_rate_code3,v_rates3,v_rate_code4,v_rates4 
                 from inv_proj_dept_ratemaster a,inv_ratemaster b,inv_ratemaster c,inv_ratemaster d,inv_ratemaster e where a.projno = invoices.projno and a.costcode = invoices.costcode 
                 and a.rate_code1 = b.rate_code and a.rate_code2 = c.rate_code and a.rate_code3 = d.rate_code and a.rate_code4 = e.rate_code; 
              exception
                 when no_data_found then
                      begin
                         select a.rate_code1,nvl(b.old_rates,0.00) as rates1,a.rate_code2,nvl(c.old_rates,0.00) as rates2,a.ratecode3,nvl(d.old_rates,0.00) as rates3,a.ratecode4,nvl(e.old_rates,0.00) as rates3 into
                         v_rate_code1,v_rates1,v_rate_code2,v_rates2,v_rate_code3,v_rates3,v_rate_code4,v_rates4 
                         from inv_dept_ratemaster a,inv_ratemaster b,inv_ratemaster c,inv_ratemaster d,inv_ratemaster e where a.costcode = invoices.costcode 
                         and a.rate_code1 = b.rate_code and a.rate_code2 = c.rate_code and a.ratecode3 = d.rate_code and a.ratecode4 = e.rate_code; 
                      exception
                         when no_data_found then
                              v_rate_code1 := 'Z1';
                              select nvl(old_rates,0.00) into v_rates1 from inv_ratemaster where rate_code = v_rate_code1;
                              v_rate_code2 := 'Z2';
                              select nvl(old_rates,0.00) into v_rates2 from inv_ratemaster where rate_code = v_rate_code2;
                              v_rate_code3 := 'Z3';
                              select nvl(old_rates,0.00) into v_rates3 from inv_ratemaster where rate_code = v_rate_code3;
                              v_rate_code4 := 'Z4';
                              select nvl(old_rates,0.00) into v_rates4 from inv_ratemaster where rate_code = v_rate_code4;
                      end;
              end;
           end if;   
           If v_rates = 0  Then
              v_rate_code := v_rate_code1;
              v_rate := v_rates1;
           Else
              v_rate_code := v_rate_code3;
              v_rate := v_rates3;
           End If;
           select tcmno into v_tcm_no from projmast where projno = invoices.projno;
  	   	   If nvl(loas.budgetted_hours,0) - (nvl(loas.ticbconsumed_hours,0)+nvl(loas.subcconsumed_hours,0)+nvl(loas.delta_hours,0)+nvl(loas.delta_current,0)) > v_balance_to_invoice Then
	 	   	   	  v_invoice_now := v_balance_to_invoice;
	 	   	   Else
	 	   	   	  v_invoice_now :=  nvl(loas.budgetted_hours,0) - (nvl(loas.ticbconsumed_hours,0)+nvl(loas.subcconsumed_hours,0)+nvl(loas.delta_hours,0)+nvl(loas.delta_current,0));
	 	   	   End If;   
    	   	 v_balance_to_invoice := v_balance_to_invoice - v_invoice_now;
    	   	 if v_invoice_now <> 0 then
    	   	 	  begin
    	   	 	     select budgetted_hours,revised_hours,
    	   	 	     ticbconsumed_hours,subcconsumed_hours,
    	   	 	     invoiced_hours,invoiced_amount+invoiced_opn_amount,
    	   	 	     delta_hours,delta_amount,delta_current,delta_current_amount,
    	   	 	     rollback_overbudget,rollback_overbudget_amount,
    	   	 	     rollback_current,rollback_current_amount 
    	   	 	     into 
    	   	 	     v_budgetted_hours,v_revised_hours,v_ticbconsumed_hours,v_subcconsumed_hours,
    	   	 	     v_invoiced_hours,v_invoiced_amount,v_delta_hours,v_delta_amount,
    	   	 	     v_delta_current,v_delta_current_amount,v_rollback_overbudget,
    	   	 	     v_rollback_overbudget_amount,v_rollback_current,v_rollback_current_amount 
    	   	 	     from inv_loa_details where projno = invoices.projno and 
    	   	 	     suborder_no = invoices.suborder_no and loa_no = invoices.loa_no and 
    	   	 	     costcode = invoices.costcode; 
    	   	 	  exception
    	   	 	  	 when others then
    	   	 	  	      null;
    	   	 	  end;   
	 	   	      update inv_invoice_master set rollback_current = nvl(rollback_current,0) + v_invoice_now where current of c_inv_delta;
	 	   	      update inv_loa_details set delta_current = nvl(delta_current,0) + v_invoice_now, delta_current_amount = nvl(delta_current_amount,0) + (v_invoice_now * v_rate) where current of c_loa_update;
	 	   	      update inv_loa_Details set rollback_current = nvl(rollback_current,0) + v_invoice_now, rollback_current_amount = nvl(rollback_current_amount,0) + (v_invoice_now * invoices.rate) where projno = invoices.projno and suborder_no = invoices.suborder_no and loa_no = invoices.loa_no and costcode = invoices.costcode;
	   	 	      select count(*) into v_return from inv_workfile1 where nvl(delta_inv,0) = 1 and projno = loas.projno and suborder_no = loas.suborder_no and loa_no = loas.loa_no and costcode = loas.costcode;
    	   	 	  if v_return = 0 then
                 insert into inv_workfile1(projno,suborder_no,loa_no,costcode,budget,
                 revised,ticb_sofar,subc_sofar,invoiced_sofar,ticb_current,subc_current,
                 invoiced_current,rate_code,rate,overbudget,yymm,invoice_no,tcm_no,
                 short_code,delta_inv,old_invoice_no,delta_sofar,delta_current,
                 invoiced_sofar_amount,delta_current_amount,rollback_sofar,rollback_sofar_amount,
                 rollback_current,rollback_current_amount,additional) 
                 values(invoices.projno,invoices.suborder_no,invoices.loa_no,invoices.costcode,v_budgetted_hours,
                 v_revised_hours,v_ticbconsumed_hours,v_subcconsumed_hours,v_invoiced_hours,0,0,
                 v_invoice_now * -1,invoices.rate_code,invoices.rate,0,p_processing_month,null,v_tcm_no,
                 invoices.short_code,1,invoices.invoice_no,v_delta_hours,v_delta_current,
                 v_invoiced_amount,v_delta_current_amount,v_rollback_overbudget,v_rollback_overbudget_amount,
                 v_rollback_current,v_rollback_current_amount,0);
    	   	 	  else
                 insert into inv_workfile1(projno,suborder_no,loa_no,costcode,budget,
                 revised,ticb_sofar,subc_sofar,invoiced_sofar,ticb_current,subc_current,
                 invoiced_current,rate_code,rate,overbudget,yymm,invoice_no,tcm_no,
                 short_code,delta_inv,old_invoice_no,delta_sofar,delta_current,
                 invoiced_sofar_amount,delta_current_amount,rollback_sofar,rollback_sofar_amount,
                 rollback_current,rollback_current_amount,additional) 
                 values(invoices.projno,invoices.suborder_no,invoices.loa_no,invoices.costcode,0,
                 0,0,0,0,0,0,
                 v_invoice_now * -1,invoices.rate_code,invoices.rate,0,p_processing_month,null,v_tcm_no,
                 invoices.short_code,1,invoices.invoice_no,0,0,
                 0,0,0,0,
                 0,0,0);
    	   	 	  end if;	
    	   	    begin
    	   	 	      select count(*) into v_return from inv_workfile1 where nvl(delta_inv,0) = 1 and projno = loas.projno and suborder_no = loas.suborder_no and loa_no = loas.loa_no and costcode = loas.costcode;
    	   	 	      if v_return > 0 then
                     insert into inv_workfile1(projno,suborder_no,loa_no,costcode,budget,
                     revised,ticb_sofar,subc_sofar,invoiced_sofar,ticb_current,subc_current,
                     invoiced_current,rate_code,rate,overbudget,yymm,invoice_no,tcm_no,
                     short_code,delta_inv,old_invoice_no,delta_sofar,delta_current,
                     invoiced_sofar_amount,delta_current_amount,rollback_sofar,rollback_sofar_amount,
                     rollback_current,rollback_current_amount,additional) 
                         values(loas.projno,loas.suborder_no,loas.loa_no,loas.costcode,0,
                     0,0,0,0,0,0,
                     v_invoice_now,v_rate_code,v_rate,0,p_processing_month,null,v_tcm_no,
                     null,1,null,0,0,
                     0,0,0,0,
                     0,0,0);
                  else       
                     insert into inv_workfile1(projno,suborder_no,loa_no,costcode,budget,
                     revised,ticb_sofar,subc_sofar,invoiced_sofar,ticb_current,subc_current,
                     invoiced_current,rate_code,rate,overbudget,yymm,invoice_no,tcm_no,
                     short_code,delta_inv,old_invoice_no,delta_sofar,delta_current,
                     invoiced_sofar_amount,delta_current_amount,rollback_sofar,rollback_sofar_amount,
                     rollback_current,rollback_current_amount,additional) 
                     values(loas.projno,loas.suborder_no,loas.loa_no,loas.costcode,loas.budgetted_hours,
                     loas.revised_hours,loas.ticbconsumed_hours,loas.subcconsumed_hours,loas.invoiced_hours,0,0,
                     v_invoice_now,v_rate_code,v_rate,0,p_processing_month,null,v_tcm_no,
                     null,1,null,loas.delta_hours,loas.delta_current,
                     nvl(loas.invoiced_amount,0)+nvl(loas.invoiced_opn_amount,0),loas.delta_current_amount,loas.rollback_overbudget,loas.rollback_overbudget_amount,
                     loas.rollback_current,loas.rollback_current_amount,0);
                  end if;            
              end;            
           end if;               
	 	   End Loop;
	 End Loop;
   --update inv_workfile1 set invoice_no = ltrim(rtrim(tcm_no)) || '-' || yymm;
   update inv_workfile1 set short_code = (select short_code from inv_ratemaster where rate_code = inv_workfile1.rate_code);
   update inv_workfile1 set eou_job = (select nvl(eou_job,0) from projmast where inv_workfile1.projno = projmast.projno);
   v_last_projno := ' ';
   v_inv_no := ' ';
   declare
   	  cursor v_c1 is select * from inv_workfile1 where nvl(delta_inv,0) = 1 and nvl(eou_job,0) = 0 order by projno for update;
   	  cursor v_c2 is select * from inv_workfile1 where nvl(delta_inv,0) = 1 and nvl(eou_job,0) = 1 order by projno for update;
   	  v_rec inv_workfile1%rowtype;
   begin	
   open v_c1;
   loop
      fetch v_c1 into v_rec;
      exit when v_c1%NOTFOUND;
      if v_rec.projno <> v_last_projno then
   	   	  v_last_projno := v_rec.projno;
   	      begin
   	   	     select last_delta_inv into v_inv_no from inv_invoice_nos where division = 'BO';
   	   	     v_inv_no := LPAD(RTRIM(LTRIM(TO_CHAR(TO_NUMBER(v_inv_no)+1))),6,'0');
   	   	     update inv_invoice_nos set last_delta_inv = v_inv_no where division = 'BO';
   	      exception
   	      	 when no_data_found then
   	      	      v_inv_no := '100001';
   	      	      insert into inv_invoice_nos(last_inv,last_delta_inv,division) values('000000',v_inv_no,'BO');
   	      	 when others then
                  dbms_output.put_line('ERROR : 1 '||SQLERRM);
                  rollback;                   	
                  raise;
   	      end;
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
   	      begin
   	   	     select last_delta_inv into v_inv_no from inv_invoice_nos where division = 'EO';
   	   	     v_inv_no := LPAD(RTRIM(LTRIM(TO_CHAR(TO_NUMBER(v_inv_no)+1))),6,'0');
   	   	     update inv_invoice_nos set last_delta_inv = v_inv_no where division = 'EO';
   	      exception
   	      	 when no_data_found then
   	      	      v_inv_no := '200001';
   	      	      insert into inv_invoice_nos(last_inv,last_delta_inv,division) values('500000',v_inv_no,'EO');
   	      	 when others then
                  dbms_output.put_line('ERROR : 1 '||SQLERRM);
                  rollback;                   	
                  raise;
   	      end;
   	   end if;
   	   update inv_workfile1 set invoice_no = v_inv_no where current of v_c2;
   end loop;
   close v_c2;
   end;
exception
   when others then
        dbms_output.put_line('ERROR : '||SQLERRM);
        rollback;                   	
        raise;
END
;

/

--------------------------------------------------------
--  DDL for Procedure POST_INVOICES
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "TIMECURR"."POST_INVOICES" IS
   v_workfile1 inv_workfile1%rowtype;
   v_yymm inv_workfile1.yymm%type;
   v_invoice_no inv_workfile1.invoice_no%type;
   v_projno inv_workfile1.projno%type;
   v_costcode inv_workfile1.costcode%type;
   v_suborder_no inv_workfile1.suborder_no%type;
   v_loa_no inv_workfile1.loa_no%type;
   v_budget inv_workfile1.budget%type :=0.00;
   v_revised inv_workfile1.revised%type :=0.00;
   v_ticb_sofar inv_workfile1.ticb_sofar%type :=0.00;
   v_subc_sofar inv_workfile1.subc_sofar%type :=0.00;
   v_invoiced_sofar inv_workfile1.invoiced_sofar%type :=0.00;
   v_ticb_current inv_workfile1.ticb_current%type :=0.00;
   v_subc_current inv_workfile1.subc_current%type :=0.00;
   v_invoiced_current inv_workfile1.invoiced_current%type :=0.00;
   v_rate_code inv_workfile1.rate_code%type;
   v_rate inv_workfile1.rate%type :=0.00;
   v_overbudget inv_workfile1.overbudget%type :=0;
   v_return number(5) :=0;
   -- Open workfile
   cursor c_workfile is select * from inv_workfile1 where nvl(additional,0) = 0 and nvl(delta_inv,0) = 0 order by yymm,invoice_no,projno,costcode,suborder_no,loa_no;
begin
   open c_workfile;
   If c_workfile%ISOPEN Then
      --- loop for entire work file
      Loop
         Fetch c_workfile into v_workfile1;
         Exit when c_workfile%NOTFOUND;
         if v_workfile1.ticb_current+v_workfile1.subc_current+v_workfile1.invoiced_current > 0.00 and nvl(v_workfile1.delta_inv,0) = 0 and nvl(v_workfile1.additional,0) = 0 then
            begin
      	       /*
      	       select count(*) into v_return from inv_loa_details where projno = v_projno and costcode = v_costcode and suborder_no = v_suborder_no and loa_no = v_loa_no;
      	       -- if not exist in loa_details
      	       if v_return = 0 then
        	        select count(*) into v_return from inv_suborder_master where projno = v_workfile1.v_projno and suborder_no = v_workfile1.v_suborder_no;
        	        -- if not exist in suborder file
        	        if v_return = 0 then
                     insert into inv_suborder_master(projno,suborder_no,dates,total_hrs) values(v_workfile1.v_projno,v_workfile1.v_suborder_no,sysdate,0);
        	        end if;	
        	        select count(*) into v_return from inv_loa_master where projno = v_projno and suborder_no = v_suborder_no and loa_no = v_loa_no;
        	        -- if not exist in loa_master file
        	        if v_return = 0 then
                     insert into inv_loa_master(projno,suborder_no,loa_no,dates,total_hrs) values(v_projno,v_suborder_no,v_loa_no,sysdate,0);
          	      end if;	
        	        -- insert into loa_details
        	        insert into inv_loa_details(projno,suborder_no,loa_no,costcode,ticbconsumed_hours,subcconsumed_hours,invoiced_hours) values(v_projno,v_suborder_no,v_loa_no,v_costcode,0.00,0.00,0.00);
        	     end if;	
        	     */
        	     --- update loa file   
      	       update inv_loa_details set ticbconsumed_hours = nvl(ticbconsumed_hours,0) + nvl(v_workfile1.ticb_current,0),
      	                               subcconsumed_hours = nvl(subcconsumed_hours,0) + nvl(v_workfile1.subc_current,0),
      	                               invoiced_hours = nvl(invoiced_hours,0) + nvl(v_workfile1.invoiced_current,0),
      	                               invoiced_amount = nvl(invoiced_amount,0) + nvl(v_workfile1.invoiced_current,0) * nvl(v_workfile1.rate,0),
      	                               invoiced_overbudget = nvl(invoiced_overbudget,0) + decode(nvl(v_workfile1.overbudget,0),1,nvl(v_workfile1.invoiced_current,0),0) 
      	              where projno = v_workfile1.projno and suborder_no = v_workfile1.suborder_no and loa_no = v_workfile1.loa_no and costcode = v_workfile1.costcode;
        	  end;
         end if;	        
      End Loop;   
      close c_workfile;
      --- insert into invoice master
      -- insert into inv_invoice_master(yymm,invoice_no,projno,costcode,suborder_no,loa_no,budget,revised,ticb_sofar,subc_sofar,invoiced_sofar,ticb_current,subc_current,invoiced_current,rate_code,rate,overbudget,allocated,tcm_no,short_code,delta_invoiced_hours,delta_inv) select yymm,invoice_no,projno,costcode,suborder_no,loa_no,budget,revised,ticb_sofar,subc_sofar,invoiced_sofar,ticb_current,subc_current,invoiced_current,rate_code,rate,overbudget,allocated,tcm_no,short_code,delta_invoiced_hours,delta_inv from inv_workfile1 where ticb_current+subc_current+invoiced_current > 0.00;
      --- delete workfile
      insert into inv_invoice_master(yymm,invoice_no,projno,costcode,suborder_no,loa_no,budget,revised,ticb_sofar,subc_sofar,invoiced_sofar,ticb_current,subc_current,invoiced_current,rate_code,rate,overbudget,tcm_no,short_code,allocated,delta_inv,rollback_overbudget,rollback_current,old_invoice_no,delta_sofar,invoiced_sofar_amount,delta_current,additional,rollback_sofar,rollback_sofar_amount,rollback_now,rollback_now_amount,delta_sofar_amount,delta_current_amount) 
      select yymm,invoice_no,projno,costcode,suborder_no,loa_no,budget,revised,ticb_sofar,subc_sofar,invoiced_sofar,ticb_current,subc_current,invoiced_current,rate_code,rate,overbudget,tcm_no,short_code,allocated,delta_inv,0,0,old_invoice_no,delta_sofar,invoiced_sofar_amount,delta_current,additional,rollback_sofar,rollback_sofar_amount,rollback_current,rollback_current_amount,delta_sofar_amount,delta_current_amount from inv_workfile1;
      delete from inv_workfile1;
      update inv_invoice_master set rollback_overbudget = nvl(rollback_overbudget,0) + nvl(rollback_current,0);
   	  update inv_invoice_master set rollback_current = 0;
   	  update inv_loa_details set delta_hours = nvl(delta_hours,0) + nvl(delta_current,0),
   	                             delta_amount = nvl(delta_amount,0) + nvl(delta_current_amount,0),
   	                             rollback_overbudget = nvl(rollback_overbudget,0) + nvl(rollback_current,0),
   	                             rollback_overbudget_amount = nvl(rollback_overbudget_amount,0) + nvl(rollback_current_amount,0);
	    update inv_loa_details set delta_current = 0,delta_current_amount = 0,rollback_current = 0,rollback_current_amount = 0;
      update inv_invoice_nos set prev_last_inv = last_inv, prev_last_delta_inv = last_delta_inv;
      commit;
   end if;   
exception
   when others then
        dbms_output.put_line('ERROR :' ||SQLERRM);
        rollback;
        raise;
END;

/

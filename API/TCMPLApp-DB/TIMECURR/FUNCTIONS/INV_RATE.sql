--------------------------------------------------------
--  DDL for Function INV_RATE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."INV_RATE" 
(
 param_projno in varchar2,
  param_dept in varchar2
) return number as 
    v_count number;
    v_rate_code1 char(2);
    v_rates number(10,2);
begin    
begin
   v_rates := 0.00;
      select RATE_CODE1  into v_rate_code1  from INV_PROJ_DEPT_RATEMASTER where PROJNO = param_projno and costcode = param_dept ;
   
exception 
      when no_data_found then
           begin
                 select RATE_CODE1 into v_rate_code1 from INV_DEPT_RATEMASTER where costcode = param_dept;
                 --  if v_rate_code1 <> '' then
                      select rates into v_rates from INV_RATEMASTER where rate_code = v_rate_code1;
                      return v_rates;
                  -- else
                  --  v_rates := 0;
                   -- return v_rates;
                   -- end if;  
           end;
           
         when others then
           begin
                 select RATE_CODE1 into v_rate_code1 from INV_DEPT_RATEMASTER where costcode = param_dept;
                   if v_rate_code1 <> '' then
                      select rates into v_rates from INV_RATEMASTER where rate_code = v_rate_code1;
                      return v_rates;
                   else
                    v_rates := 0;
                    return v_rates;
                    end if;  
           end;  
           
           
          
   --             select RATE_CODE1  into v_rate_code1  from INV_DEPT_RATEMASTER where costcode = param_dept;
   --           when no_data_found then
   --           begin              
       -- return v_rates;
end ;
--select RATE_CODE1 into v_rate_code1 from INV_DEPT_RATEMASTER where costcode = param_dept;
  select rates into v_rates from INV_RATEMASTER where rate_code = v_rate_code1;
                      return v_rates;

end;

/

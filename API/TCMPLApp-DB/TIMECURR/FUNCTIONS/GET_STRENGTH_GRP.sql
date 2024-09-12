--------------------------------------------------------
--  DDL for Function GET_STRENGTH_GRP
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."GET_STRENGTH_GRP" (p_grp costmast.costcode%type) return number is
   p_strength costmast.noofemps%type;
begin
   p_strength := 0;
   if p_grp = 'E' then
      select  SUM( nvl(noofemps,0) + nvl(NOOFCONS,0)) into p_strength from costmast where GROUP_CHART= 1 and   costcode like '02%' and tma_grp = p_grp;
   else
      if p_grp = 'N'  then 
         select   SUM(nvl(noofemps,0) + nvl(NOOFCONS,0)) into p_strength from costmast where  GROUP_CHART= 1 and  costcode like '02%' and  tma_grp <> p_grp;
      else
         if p_grp = 'B' then
            select   SUM(nvl(noofemps,0) + nvl(NOOFCONS,0)) into p_strength from costmast where GROUP_CHART= 1 and costcode like '02%';
         else
            p_strength := 0;
         end if;
     end if;    
  end if;   
         return p_strength;
exception   
   when no_data_found then
        p_strength := 0;
        return p_strength;
end;

/

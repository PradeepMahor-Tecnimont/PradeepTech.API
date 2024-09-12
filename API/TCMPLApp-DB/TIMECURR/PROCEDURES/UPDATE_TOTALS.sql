--------------------------------------------------------
--  DDL for Procedure UPDATE_TOTALS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "TIMECURR"."UPDATE_TOTALS" (Proc_Month In Timetran.Yymm%Type) As

BEGIN
   update time_daily set total =  (NVL(D1,0))+ (NVL(D2,0))+ (NVL(D3,0))+ (NVL(D4,0))+ (NVL(D5,0))+ (NVL(D6,0))+ (NVL(D7,0))
+ (NVL(D8,0))+
 (NVL(D9,0))+ (NVL(D10,0))+ (NVL(D11,0))+ (NVL(D12,0))+ (NVL(D13,0))+ (NVL(D14,0))+ (NVL(D15,0))
+ (NVL(D16,0))+ (NVL(D17,0))+
 (NVL(D18,0))+ (NVL(D19,0))+ (NVL(D20,0))+ (NVL(D21,0))+ (NVL(D22,0))+ (NVL(D23,0))
+ (NVL(D24,0))+ (NVL(D25,0))+ (NVL(D26,0))+
 (NVL(D27,0))+ (NVL(D28,0))+ (NVL(D29,0))+ (NVL(D30,0))+ (NVL(D31,0))  
WHERE 
 (NVL(D1,0))+ (NVL(D2,0))+ (NVL(D3,0))+ (NVL(D4,0))+ (NVL(D5,0))+ (NVL(D6,0))+ (NVL(D7,0))
+ (NVL(D8,0))+
 (NVL(D9,0))+ (NVL(D10,0))+ (NVL(D11,0))+ (NVL(D12,0))+ (NVL(D13,0))+ (NVL(D14,0))+ (NVL(D15,0))
+ (NVL(D16,0))+ (NVL(D17,0))+
 (NVL(D18,0))+ (NVL(D19,0))+ (NVL(D20,0))+ (NVL(D21,0))+ (NVL(D22,0))+ (NVL(D23,0))
+ (NVL(D24,0))+ (NVL(D25,0))+ (NVL(D26,0))+
 (Nvl(D27,0))+ (Nvl(D28,0))+ (Nvl(D29,0))+ (Nvl(D30,0))+ (Nvl(D31,0))
<> NVL(TOTAL,0) AND YYMM =  PROC_MONTH ;
   commit;
   EXCEPTION
   	 when others then
        dbms_output.put_line('ERROR : '||SQLERRM);
        rollback;            
        Raise;    


   update time_ot set total =  (NVL(D1,0))+ (NVL(D2,0))+ (NVL(D3,0))+ (NVL(D4,0))+ (NVL(D5,0))+ (NVL(D6,0))+ (NVL(D7,0))
+ (NVL(D8,0))+
 (NVL(D9,0))+ (NVL(D10,0))+ (NVL(D11,0))+ (NVL(D12,0))+ (NVL(D13,0))+ (NVL(D14,0))+ (NVL(D15,0))
+ (NVL(D16,0))+ (NVL(D17,0))+
 (NVL(D18,0))+ (NVL(D19,0))+ (NVL(D20,0))+ (NVL(D21,0))+ (NVL(D22,0))+ (NVL(D23,0))
+ (NVL(D24,0))+ (NVL(D25,0))+ (NVL(D26,0))+
 (NVL(D27,0))+ (NVL(D28,0))+ (NVL(D29,0))+ (NVL(D30,0))+ (NVL(D31,0))  
WHERE 
 (NVL(D1,0))+ (NVL(D2,0))+ (NVL(D3,0))+ (NVL(D4,0))+ (NVL(D5,0))+ (NVL(D6,0))+ (NVL(D7,0))
+ (NVL(D8,0))+
 (NVL(D9,0))+ (NVL(D10,0))+ (NVL(D11,0))+ (NVL(D12,0))+ (NVL(D13,0))+ (NVL(D14,0))+ (NVL(D15,0))
+ (NVL(D16,0))+ (NVL(D17,0))+
 (NVL(D18,0))+ (NVL(D19,0))+ (NVL(D20,0))+ (NVL(D21,0))+ (NVL(D22,0))+ (NVL(D23,0))
+ (NVL(D24,0))+ (NVL(D25,0))+ (NVL(D26,0))+
 (NVL(D27,0))+ (NVL(D28,0))+ (NVL(D29,0))+ (NVL(D30,0))+ (NVL(D31,0))
<> NVL(TOTAL,0) AND YYMM =  PROC_MONTH
   commit;
   EXCEPTION
   	 when others then
        dbms_output.put_line('ERROR : '||SQLERRM);
        rollback;            
        raise;    

end;

/

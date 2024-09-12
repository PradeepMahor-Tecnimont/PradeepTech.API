--------------------------------------------------------
--  DDL for Function FIRSTLASTPUNCH
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."FIRSTLASTPUNCH" (EmpNum IN Varchar2, PunchDate IN Date,FirstLast In Number) RETURN number IS
	Cursor C1 is select * from SS_Punch 
		where EmpNo = ltrim(rtrim(EmpNum))
		and PDate = PunchDate;
	Type TabHrsRec is record (TabHrs number, TabMns number);
	Type TabHrs  is table of TabHrsRec index by Binary_Integer;
	V_TabHrs TabHrs;
	Cntr Number;
BEGIN
	Cntr := 1;
	For C2 in C1 Loop
		V_TabHrs(Cntr).TabHrs := C2.HH;
		V_TabHrs(Cntr).TabMns := C2.MM;
		Cntr := Cntr + 1;
	End Loop;
	Cntr := Cntr - 1;
	If FirstLast = 0 then
		return (V_TabHrs(1).TabHrs * 60) + V_TabHrs(1).TabMns;
	Else
		Return (V_TabHrs(Cntr).TabHrs * 60) + V_TabHrs(Cntr).TabMns;
	End If;
end;


/

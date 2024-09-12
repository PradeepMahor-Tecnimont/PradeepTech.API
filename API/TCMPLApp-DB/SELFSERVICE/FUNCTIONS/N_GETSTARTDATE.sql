--------------------------------------------------------
--  DDL for Function N_GETSTARTDATE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."N_GETSTARTDATE" (p_MM In Varchar2, p_YYYY In Varchar2) RETURN Date IS
	v_dDate Date;
	v_RetDate Date;
	v_Date Date;
BEGIN
	v_Date := To_Date('01-' || p_MM || '-' || p_YYYY, 'dd-mm-yyyy');
  If Upper(To_Char(v_Date,'DY')) <> 'MON' Then
  		v_dDate := v_Date - 1;
  		Select Min(D_Date) InTo v_RetDate From SS_Days_Details Where Wk_Of_Year = LPad(To_Char(v_dDate,'IW'),2,'0')
  		And d_YYYY = To_Char(v_dDate,'yyyy')
  		And d_MM = To_Char(v_dDate,'mm');
  		Return v_RetDate;
  Else
  		Return v_Date;
  End If;
Exception
		When others then
			return null;
END;


/

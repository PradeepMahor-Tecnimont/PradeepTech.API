--------------------------------------------------------
--  DDL for Procedure INSERT_DATES
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SELFSERVICE"."INSERT_DATES" (p_YYYY In Varchar2) IS
		d_Date Date;
		d_iDate Date;
BEGIN
		If Length(p_YYYY) = 4 Then
  		d_Date := To_Date('1-jan-' || p_yyyy, 'dd-mm-yyyy');
  		Delete from SS_Days_Details Where d_YYYY = p_YYYY;
  		Commit;
  		For i In 1..366 Loop
  				d_iDate := (d_Date + (i-1));
  				Insert Into SS_Days_Details 
  					values
  						(
  							d_iDate, 
  							LPad(To_Char(d_iDate,'dd'),2,'0'),
  							LPad(To_Char(d_iDate,'mm'),2,'0'),
  							LPad(To_Char(d_iDate,'yyyy'),4,'0'),
  							To_Char(d_iDate,'MON'),
  							To_Char(d_iDate,'DY'),
  							LPad(To_Char(d_iDate,'IW'),2,'0')
  						);
  				Commit;
  		End Loop;
  	End If;
END;


/

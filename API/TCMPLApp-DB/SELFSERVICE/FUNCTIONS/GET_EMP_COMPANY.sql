--------------------------------------------------------
--  DDL for Function GET_EMP_COMPANY
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."GET_EMP_COMPANY" (pEmpNo IN VARCHAR, pDate IN DATE)  RETURN VARCHAR IS
		varRetCompany		CHAR (4);
BEGIN

  	Select Company InTo varRetCompany From ( Select Company From SS_EMP_COMP_LASTDATE_4_MUSTER Where EmpNo = pEmpNo And
  		LastDate >= pDate Order by LastDate Desc ) Where RowNum = 1;
  	Return varRetCompany;
Exception
    When NO_DATA_FOUND Then
        Begin
            Select Company InTo varRetCompany From SS_EmplMast Where Empno = pEmpNo;
            Return varRetCompany;
        Exception
            When NO_DATA_FOUND Then
                Return ' ';
        END;
    When Others Then
            Return ' ';
END;


/

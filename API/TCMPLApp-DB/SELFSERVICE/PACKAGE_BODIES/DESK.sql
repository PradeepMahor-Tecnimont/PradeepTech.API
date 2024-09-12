--------------------------------------------------------
--  DDL for Package Body DESK
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."DESK" AS

  FUNCTION GetDesk(pEmpNo In Varchar2) RETURN Varchar2  AS
    vCount Number;
    vDeskID Varchar2(30);
  BEGIN
    vDeskID := '';
    Select count(*) INTO vCount From SS_DESKASSIGNMENT Where EmpNo = pEmpNo and flag_apprd = 1;
    If vCount >= 1 Then
      Select DeskID Into vDeskID From 
      ( Select DeskID From SS_DESKASSIGNMENT Where EmpNo = pEmpNo and flag_apprd = 1 Order By trans_date Desc )
      Where rownum = 1;
    Else
      Select count(*) INTO vCount From SS_DESKASSIGNMENT_20091127 Where EmpNo = pEmpNo ;
      If vCount > 0 Then
        Select DeskID INTO vDeskID From SS_DESKASSIGNMENT_20091127 Where EmpNo = pEmpNo ;
      End If;
    End If;
    Return vDeskID;
    EXCEPTION
      when Others then
      Return '';
  END GetDesk;

  FUNCTION GetComp(pEmpNo In Varchar2) RETURN Varchar2  AS
    vCount Number;
    vCompName Varchar2(30);
  BEGIN
    vCompName := '';
    Select count(*) INTO vCount From SS_DESKASSIGNMENT Where EmpNo = pEmpNo and flag_apprd = 1;
    If vCount >= 1 Then
      Select CompName Into vCompName From 
      ( Select CompName From SS_DESKASSIGNMENT Where EmpNo = pEmpNo and flag_apprd = 1 Order By trans_date Desc )
      Where rownum = 1;
    Else
      Select count(*) INTO vCount From SS_DESKASSIGNMENT_20091127 Where EmpNo = pEmpNo ;
      If vCount > 0 Then
        Select CompName INTO vCompName From SS_DESKASSIGNMENT_20091127 Where EmpNo = pEmpNo ;
      End If;
    End If;
    Return vCompName;
    EXCEPTION
      when Others then
      Return '';
  END GetComp;

  FUNCTION GetDMUid(param_Flag in Number) RETURN Varchar2 AS    
    BEGIN
      if param_Flag = 1 then
        c_dm_sessionid := DBMS_SESSION.UNIQUE_SESSION_ID;
        c_dm_uniqueid := DBMS_RANDOM.string('X',11);      
        return c_dm_uniqueid;
      else 
        if c_dm_sessionid = DBMS_SESSION.UNIQUE_SESSION_ID then
            return c_dm_uniqueid;
        end if;        
      end if;
      return '';
  END GetDMUid;

  FUNCTION GetEmployees(param_Desk in varchar2) RETURN Varchar2 AS
      vEmpoyees Varchar2(50);
      cursor c1 is select empno from ss_deskassignment 
        where upper(trim(deskid)) = upper(trim(param_Desk));
      string_v varchar2(50);
    BEGIN      
      open c1;
      loop
        fetch c1 into string_v;
          if c1%notfound then exit; end if;
          vEmpoyees := vEmpoyees||','||string_v;
      end loop;
      close c1;
      vEmpoyees := substr(vEmpoyees,2);
      return vEmpoyees;
  END GetEmployees;

  function get_barcode_old(p_assetid in varchar2) return varchar2 as
      v_barcodeold varchar2(13);
    begin
      select barcode into v_barcodeold from dm_ams_transcode
      where trim(ams_asset_id) = trim(p_assetid);
      return v_barcodeold;
  end get_barcode_old;
END DESK;


/

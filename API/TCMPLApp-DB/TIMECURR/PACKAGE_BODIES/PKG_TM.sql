--------------------------------------------------------
--  DDL for Package Body PKG_TM
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "TIMECURR"."PKG_TM" AS

    function apps_server return varchar2 AS
    BEGIN
    -- TODO: Implementation required for function PKG_ITDL.rep_env_id
    RETURN c_apps_server;
  END apps_server;

FUNCTION GetFinYearStart
  RETURN DATE
AS
BEGIN
  RETURN pkg_TM.FinYearStart;
END;
FUNCTION GetFinYearEnd
  RETURN DATE
AS
BEGIN
  RETURN PKG_TM.FinYearEnd;
END;


FUNCTION GetCalYearStart
  RETURN DATE
AS
BEGIN
  RETURN pkg_TM.CalYearStart;
END;
FUNCTION GetCalYearEnd
  RETURN DATE
AS
BEGIN
  RETURN PKG_TM.CalYearEnd;
END;

END PKG_TM;

/

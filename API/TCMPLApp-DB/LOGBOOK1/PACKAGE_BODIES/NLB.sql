--------------------------------------------------------
--  DDL for Package Body NLB
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "LOGBOOK1"."NLB" as


  FUNCTION rep_srv_nm RETURN VARCHAR2 AS
  BEGIN
    RETURN c_rep_srv_nm;
  END rep_srv_nm;
  
  FUNCTION rep_srv_url RETURN VARCHAR2 AS
  BEGIN
    RETURN c_rep_srv_url;
  END rep_srv_url;
  
  FUNCTION rep_env_id RETURN VARCHAR2 AS
  BEGIN
    RETURN c_rep_env_id;
  END rep_env_id;


end nlb;

/

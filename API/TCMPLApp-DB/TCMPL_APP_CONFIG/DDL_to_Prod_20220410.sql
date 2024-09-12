--------------------------------------------------------
--  File created - Sunday-April-10-2022   
--------------------------------------------------------
---------------------------
--Changed TABLE
--SEC_MODULE_USERS_ROLES_ACTIONS
---------------------------
ALTER TABLE "TCMPL_APP_CONFIG"."SEC_MODULE_USERS_ROLES_ACTIONS" MODIFY CONSTRAINT "SEC_MODULE_USERS_ROLES_ACT_PK" ENABLE;

---------------------------
--New INDEX
--SEC_MODULE_USERS_ROLES_ACT_PK
---------------------------
  CREATE UNIQUE INDEX "TCMPL_APP_CONFIG"."SEC_MODULE_USERS_ROLES_ACT_PK" ON "TCMPL_APP_CONFIG"."SEC_MODULE_USERS_ROLES_ACTIONS" ("MODULE_ID","EMPNO","ROLE_ID","ACTION_ID");

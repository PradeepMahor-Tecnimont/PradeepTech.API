--------------------------------------------------------
--  DDL for View VU_JOBMASTER
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VU_JOBMASTER" ("PROJNO", "PHASE", "FORM_MODE", "REVISION", "FORM_DATE", "SHORT_DESC", "CLIENT_NAME", "LOCATION", "CONTRACTUAL_LANGUAGE", "LOI_CONTRACT_NO", "LOI_CONTRACT_DATE", "PAYABLEBY_TICB", "PO_ALLOWED", "REPETITIVE", "BUDGET_ATTACHED", "SCOPE_OF_WORK", "TYPE_OF_JOB", "DESCRIPTION", "NOTES", "PM_EMPNO", "DIRVP_EMPNO", "JOB_OPEN_DATE", "EXPECTED_CLOSING_DATE", "CLOSING_DATE_REV1", "CLOSING_DATE_REV2", "ACTUAL_CLOSING_DATE", "COSTCODE", "CLIENT", "APPROVED_VPDIR", "APPROVED_DIROP", "DIROP_EMPNO", "APPROVED_AMFI", "AMFI_EMPNO", "AMFI_USER", "PROJ", "QUAL", "PROCS", "STEQU", "PIPIN", "ELECT", "INSTR", "CIVI", "MATH", "MACH", "HSE", "PROCU", "INSPX", "PROCO", "EDP", "CONST", "AMFI", "HRD", "ELECO", "INSCO", "PDS", "DIRMAT", "VPBD", "VPCAUS", "VPCHEM", "VPCONT", "VPPOFFER", "VPFERT", "VPPENG", "VC_MD", "COSEC", "DIROP", "DIRCO", "ENTRY_DATE", "ENTRY_EMPNO", "ENTRY_USER", "ENTRY_IP", "PROJTYPE", "PM_COSTCODE", "OTHEREXP_REIMB", "COMPANY", "LOC", "BU_TYPE", "CONTRACT_TYPE", "INDUSTRY", "GROUPCODE", "LINEOFBU", "JOBID", "INCHARGE", "COSTGROUP", "IED", "TCM", "OFFER", "SUBCONT", "TRACU", "PROCRD", "LOGCO", "BUDE", "TYPEOFJOB", "OPENING_MONTH", "APPDT_VPDIR", "APPDT_DIROP", "APPDT_AMFI", "APPDT_PM", "T_PLANT", "T_KIND", "T_CLIENT", "T_LOCATION", "T_COUNTRY", "JOBINCH_APPREQ", "PROJA", "PRENG", "PMB", "TCMNO", "EOU_JOB", "EXCL_BILLING", "EXCL_DELTA_BILLING", "TCM_JOBS", "TCM_GRP", "TMA_GRP", "PRJOPER", "DUMMY", "REIMB_JOB", "AWARDISSUED", "COMPLETIONISSUED", "APPRECIATIONISSUED", "CONTRACTVALUE", "FREQ_PERF_MEAS", "BLOCK_BOOKING_TIMESHEET", "CO", "NEWCOSTCODE", "OUTLOOKSOFT_PROJNO", "ELIN", "PDESI", "BLOCK_OT", "CC_237", "CC_251", "CC_290", "CC_292", "CC_246", "CC_247", "CC_217", "CC_211", "CC_296", "CC_285", "CC_242", "PROPOSAL", "CC_360", "PC_EMP", "PPC_EMP", "PCONST_EMP", "PSHIP_EMP", "PINSP_EMP", "PC_SAP", "PPC_SAP", "PCONST_SAP", "PSHIP_SAP", "PINSP_SAP", "ETENDERING", "SAP_WBS", "PREVCO", "CC_204", "CC_302", "CC_320", "CC_385", "CC_330", "CC_252", "CC_283", "CC_286", "CC_214", "CC_234", "CC_343", "CC_331") AS 
  select "PROJNO","PHASE","FORM_MODE","REVISION","FORM_DATE","SHORT_DESC","CLIENT_NAME","LOCATION","CONTRACTUAL_LANGUAGE","LOI_CONTRACT_NO","LOI_CONTRACT_DATE","PAYABLEBY_TICB","PO_ALLOWED","REPETITIVE","BUDGET_ATTACHED","SCOPE_OF_WORK","TYPE_OF_JOB","DESCRIPTION","NOTES","PM_EMPNO","DIRVP_EMPNO","JOB_OPEN_DATE","EXPECTED_CLOSING_DATE","CLOSING_DATE_REV1","CLOSING_DATE_REV2","ACTUAL_CLOSING_DATE","COSTCODE","CLIENT","APPROVED_VPDIR","APPROVED_DIROP","DIROP_EMPNO","APPROVED_AMFI","AMFI_EMPNO","AMFI_USER","PROJ","QUAL","PROCS","STEQU","PIPIN","ELECT","INSTR","CIVI","MATH","MACH","HSE","PROCU","INSPX","PROCO","EDP","CONST","AMFI","HRD","ELECO","INSCO","PDS","DIRMAT","VPBD","VPCAUS","VPCHEM","VPCONT","VPPOFFER","VPFERT","VPPENG","VC_MD","COSEC","DIROP","DIRCO","ENTRY_DATE","ENTRY_EMPNO","ENTRY_USER","ENTRY_IP","PROJTYPE","PM_COSTCODE","OTHEREXP_REIMB","COMPANY","LOC","BU_TYPE","CONTRACT_TYPE","INDUSTRY","GROUPCODE","LINEOFBU","JOBID","INCHARGE","COSTGROUP","IED","TCM","OFFER","SUBCONT","TRACU","PROCRD","LOGCO","BUDE","TYPEOFJOB","OPENING_MONTH","APPDT_VPDIR","APPDT_DIROP","APPDT_AMFI","APPDT_PM","T_PLANT","T_KIND","T_CLIENT","T_LOCATION","T_COUNTRY","JOBINCH_APPREQ","PROJA","PRENG","PMB","TCMNO","EOU_JOB","EXCL_BILLING","EXCL_DELTA_BILLING","TCM_JOBS","TCM_GRP","TMA_GRP","PRJOPER","DUMMY","REIMB_JOB","AWARDISSUED","COMPLETIONISSUED","APPRECIATIONISSUED","CONTRACTVALUE","FREQ_PERF_MEAS","BLOCK_BOOKING_TIMESHEET","CO","NEWCOSTCODE","OUTLOOKSOFT_PROJNO","ELIN","PDESI","BLOCK_OT","CC_237","CC_251","CC_290","CC_292","CC_246","CC_247","CC_217","CC_211","CC_296","CC_285","CC_242","PROPOSAL","CC_360","PC_EMP","PPC_EMP","PCONST_EMP","PSHIP_EMP","PINSP_EMP","PC_SAP","PPC_SAP","PCONST_SAP","PSHIP_SAP","PINSP_SAP","ETENDERING","SAP_WBS","PREVCO","CC_204","CC_302","CC_320","CC_385","CC_330","CC_252","CC_283","CC_286","CC_214","CC_234","CC_343","CC_331" from commonmasters.jobmaster
;

--------------------------------------------------------
--  Constraints for Table AFC_LC_MILESTONES
--------------------------------------------------------

  ALTER TABLE "AFC_LC_MILESTONES" ADD PRIMARY KEY ("MILESTONE_KEY_ID")
  USING INDEX  ENABLE;
  ALTER TABLE "AFC_LC_MILESTONES" MODIFY ("IS_ACTIVE" NOT NULL ENABLE);
  ALTER TABLE "AFC_LC_MILESTONES" MODIFY ("MILESTONE_DESC" NOT NULL ENABLE);

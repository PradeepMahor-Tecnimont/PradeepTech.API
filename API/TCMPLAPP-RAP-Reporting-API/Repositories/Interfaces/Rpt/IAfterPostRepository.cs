namespace RapReportingApi.Repositories.Interfaces.Rpt
{
    public interface IAfterPostProjRepository
    {
        object Proj_GRADE(string projno, string yymm);

        object Proj_PlanRep1(string projno, string yymm);

        object Proj_PlanRep2(string projno, string yymm);

        object Proj_ACC_ACT_BUDG(string projno);

        object Proj_Cost_combine(string projno);

        object Proj_CostOT_combine(string projno);

        object Proj_hrs_OtBreak(string projno, string yymm);

        object Proj_hrs_OtCrossTab(string projno, string yymm);

        object Proj_WorkPosition_Combine(string projno, string yymm);

        object PRJ_CC_ACT_BUDG(string projno);
    }

    public interface IAfterPostCostRepository
    {
        object CostCentre_PlanRep1(string CoseCode, string yymm);

        object CostCentre_PlanRep2(string CoseCode, string yymm);

        object CostCentre_Cost_combine(string CoseCode);

        object CostCentre_CostOT_combine(string CoseCode);

        object CostCentre_hrs_OtBreak(string CoseCode, string yymm);

        object CostCentre_hrs_OtCrossTab(string CoseCode, string yymm);

        public object ProjectwiseManhoursList(string yymm, string projno, string costcode);
    }
}
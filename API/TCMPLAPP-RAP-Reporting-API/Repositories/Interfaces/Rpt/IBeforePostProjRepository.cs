namespace RapReportingApi.Repositories.Interfaces.Rpt
{
    public interface IBeforePostProjRepository
    {
        object YY_PRJ_CC(string projno, string yymm);

        object YY_PRJ_CC_ACT(string projno, string yymm);

        object YY_PRJ_CC_EMP(string projno, string yymm);

        object MJM_Proj_All_RptDownload(string yymm, string projno);
    }
}
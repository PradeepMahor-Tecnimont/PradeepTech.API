namespace RapReportingApi.Repositories.Interfaces.Rpt.Cmplx.proco
{
    public interface ITM01AllRepository
    {
        object GetProjectList(string yymm, string simul, string reportMode, string code);

        object GetProjectData(string projno);

        object GetTM011AllDataOld(string projno, string yymm, string simul, string yearmode);

        object GetTM011AllData(string activeYear, string yymm, string simul, string yearmode, string projno, string reportMode, string code);
    }
}
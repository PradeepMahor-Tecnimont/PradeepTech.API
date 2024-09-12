namespace RapReportingApi.Repositories.Interfaces.Rpt.Cmplx.proco
{
    public interface IWorkloadRepository
    {
        object GetCostcodeList(string sheetname);

        object GetExptProjList();

        object GetWorkloadData(string costcode, string yymm, string simul, string yearmode, string activeYear, string reportMode);
    }
}
namespace RapReportingApi.Repositories.Interfaces.Rpt.Cmplx.proco
{
    public interface IResourceRepository
    {
        object GetCostcodeList();

        object GetResourceData(string timesheet_yyyy, string costcode, string yymm, string yearmode);
    }
}
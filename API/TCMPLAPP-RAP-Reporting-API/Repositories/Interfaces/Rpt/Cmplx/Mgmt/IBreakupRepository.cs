namespace RapReportingApi.Repositories.Interfaces.Rpt.Cmplx.Mgmt
{
    public interface IBreakupRepository
    {
        object GetTMAGroup();

        object GetBreakupData(string yymm, string category, string yearmode);

        object GetPlantEnggCostcodeList(string yymm);

        object GetPlantEnggData(string costcode, string yymm);
    }
}
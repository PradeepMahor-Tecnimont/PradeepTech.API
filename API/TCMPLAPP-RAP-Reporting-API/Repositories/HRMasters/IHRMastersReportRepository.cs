namespace RapReportingApi.Repositories.HRMasters
{
    public interface IHRMastersReportRepository
    {
        object MonthlyConsolidatedData(string yymm);

        object MonthlyConsolidatedEnggData(string yymm);

        object OutsourceEmployeeData(string yymm);
    }
}
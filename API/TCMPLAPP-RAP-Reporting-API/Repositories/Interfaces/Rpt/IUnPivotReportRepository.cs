namespace RapReportingApi.Repositories.Interfaces.Rpt
{
    public interface IUnPivotReportRepository
    {
        string ProcessData(string yymm, string RepFor);

        object WkJob(string FromDate, string ToDate, string Assign);

        object WkMJEAM(string FromDate, string ToDate, string Assign);

        object WKMJEM(string FromDate, string ToDate, string Assign);

        object WKMJEMP(string FromDate, string ToDate, string ProjNo);

        object GetProcessStatus(string yymm, string RepFor);

        public object GetData4CostCenter(string pYYYYMM, string pAssign);

        public object GetData4Project(string pYYYYMM, string pAssign);
    }
}
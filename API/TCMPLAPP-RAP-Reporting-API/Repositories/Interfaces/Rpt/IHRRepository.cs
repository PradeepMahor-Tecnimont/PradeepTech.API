namespace RapReportingApi.Repositories.Interfaces.Rpt
{
    public interface IHRRepository
    {
        object Employee_2011onwards(string EmpNo);

        object SUBCONTRACTOR_TS(string yymm);

        object TSPENDING(string Yymm, string ReportType);

        object LeaveHRReport(string yymm);

        byte[] getDownLoadTimesheet(string empno, string yymm);
    }
}
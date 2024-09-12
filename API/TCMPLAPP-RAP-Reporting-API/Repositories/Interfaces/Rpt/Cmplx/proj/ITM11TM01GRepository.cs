namespace RapReportingApi.Repositories.Interfaces.Rpt.Cmplx.CC.proj
{
    public interface ITM11TM01GRepository
    {
        object TM11AData(string projno, string yymm, string yearmode);

        object TM11TM01Data_Old(string projno, string yymm, string yearmode, string yyyy);

        object TM11TM01Data(string projno, string yymm, string yearmode, string yyyy);

        object TM11BData(string projno, string yymm, string yearmode, string yyyy);

        object getProjectsTCMJobsGrp(string yymm);
    }
}
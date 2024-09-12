namespace RapReportingApi.Repositories.Interfaces.Rpt
{
    public interface IAfterPostAFCRepository
    {
        //object AuditorOld(string yymm);

        object Auditor(string yymm, string activeyear);

        //object Finance_TS(string yymm);
        object Finance_TS(string yymm, string yearmode, string activeyear);

        public object JOB_PROJ_PH_LIST(string yymm);

        public object AuditorSubcontractorWiseList(string yymm, string yearmode, string activeyear);

        public object CovidManhrsDistributionReport(string yymm, string costcode, string projno);

        public object ManhourExportToSAPList(string yymm, string reporttype, string costcode, string projno, string emptype);
    }
}
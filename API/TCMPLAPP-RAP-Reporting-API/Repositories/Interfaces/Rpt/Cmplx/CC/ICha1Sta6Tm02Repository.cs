namespace RapReportingApi.Repositories.Interfaces
{
    public interface ICha1Sta6Tm02Repository
    {
        //STA6 TM02 ACT01
        object sta6tm02act01(string costCode, string yymm, string yearmode, string reportMode, string activeyear);

        //CHA1E
        object CHA01EData(string costcode, string yymm, string yearmode, string reportMode, string activeyear);

        object getRptCostcodes();

        object insertRptProcess(string keyid, string userid, string yyyy, string yymm, string yearmode, string category, string reporttype, string simul, string reportid);

        object discardRptProcess(string keyid, string userid);

        object getRptMailDetails(string keyid, string status);

        object getRptProcessList(string userid, string yyyy, string yymm, string yearmode, string reportid);

        object reportProcessStatus(string reportid, string userid, string yyyy, string yymm, string yearmode, string category, string reporttype);

        object reportProcessKeyid(string reportid, string userid, string yyyy, string yymm, string yearmode, string category, string reporttype);

        object getList4WorkerProcess();

        object addProcessQueue(string empno, string moduleid, string processid, string processdesc, string parameterFilter);
    }
}
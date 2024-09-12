namespace RapReportingApi.Repositories.Interfaces.Rpt.Cmplx.CC
{
    public interface ICHA01ERepository
    {
        object CHA01EData(string costcode, string yymm, string yearmode, string reportMode, string activeyear);

        object CHA01ESimData(string costcode, string yymm, string yearmode, string simul, string reportMode, string activeYear);

        object getCha1Costcodes();

        object getCha1Processlist(string yyyy, string userid);

        object insertCha1Process(string keyid, string userid, string yyyy, string yymm);
    }
}
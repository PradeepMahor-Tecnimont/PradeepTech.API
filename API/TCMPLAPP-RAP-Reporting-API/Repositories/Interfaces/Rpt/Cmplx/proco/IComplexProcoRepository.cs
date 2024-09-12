namespace RapReportingApi.Repositories.Interfaces.Rpt.Cmplx.proco
{
    public interface IComplexProcoRepository
    {
        object PRJCCTCData(string yymm, string yearmode);

        object ReimbPOData(string yymm);

        object OutsideSubcontractData(string yyyy, string yearmode, string yymm, string costcode);
    }
}
namespace RapReportingApi.Repositories.Interfaces
{
    public interface ITMARepository
    {
        //TMA
        object tma(string yymm, string yearmode, string reporttype, string activeyear);
    }
}
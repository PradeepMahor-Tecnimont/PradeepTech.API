namespace RapReportingApi.Repositories.Interfaces
{
    public interface IDuplTm02Repository
    {
        //TM02
        object tm02(string costCode, string yymm, string yearmode, string activeyear);
    }
}
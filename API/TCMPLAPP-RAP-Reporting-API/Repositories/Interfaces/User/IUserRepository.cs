namespace RapReportingApi.Repositories.Interfaces.User
{
    public interface IUserRepository
    {       
        object getProcessingMonth();

        object getStartMonth(string yearmode);
    }
}
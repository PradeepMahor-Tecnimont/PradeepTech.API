using Microsoft.Extensions.Logging;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.HRMasters;

namespace TCMPLApp.DataAccess.Repositories.HRMasters
{
    public class EmployeeImportRepository : ExecTcmPLRepository<ParameterSpTcmPL, EmployeesOutput>, IEmployeeImportRepository
    {

        public EmployeeImportRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context,  logger)
        {
            
        }

        public async Task<EmployeesOutput> ImportEmployeesAsync(
            BaseSpTcmPL baseSpTcmPL,
            ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.hr_pkg_emplmast_main.import_employees";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            //var tags = new string[] {
            //    $"USER/{ baseSpTcmPL.UIUserId }"
            //};
            //await _redisContext.Cache.InvalidateKeysByTagAsync(tags);

            return response;

        }


    }
}

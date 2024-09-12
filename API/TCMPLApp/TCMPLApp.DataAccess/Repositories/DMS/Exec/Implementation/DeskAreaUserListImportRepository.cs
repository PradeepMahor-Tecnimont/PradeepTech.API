using Microsoft.Extensions.Logging;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public class DeskAreaUserListImportRepository : ExecTcmPLRepository<ParameterSpTcmPL, DeskAreaUserImportOutput>, IDeskAreaUserListImportRepository
    { 
        public DeskAreaUserListImportRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {

        }

        public async Task<DeskAreaUserImportOutput> ImportDeskAreaUserListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dms_masters.sp_import_desk_area_user";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }        
    }
}

using Microsoft.Extensions.Logging;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public class DeskAreaDeskListImportRepository : ExecTcmPLRepository<ParameterSpTcmPL, DeskAreaDeskImportOutput>, IDeskAreaDeskListImportRepository
    { 
        public DeskAreaDeskListImportRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {

        }

        public async Task<DeskAreaDeskImportOutput> ImportDeskAreaDeskListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dms_masters.sp_import_desk_area_desk";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }        
    }
}

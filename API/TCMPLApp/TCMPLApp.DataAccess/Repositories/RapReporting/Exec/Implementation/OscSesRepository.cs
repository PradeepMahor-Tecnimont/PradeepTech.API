using DocumentFormat.OpenXml.Spreadsheet;
using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.DataAccess.Repositories.RapReporting
{
    public class OscSesRepository : ExecTcmPLRepository<ParameterSpTcmPL, DBProcMessageOutput>, IOscSesRepository
    {
        public OscSesRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<DBProcMessageOutput> OscSesCreateAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.pkg_rap_osc_ses.sp_add_osc_ses";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }

        public async Task<DBProcMessageOutput> OscSesEditAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.pkg_rap_osc_ses.sp_update_osc_ses";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }

        public async Task<DBProcMessageOutput> OscSesDeleteAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.pkg_rap_osc_ses.sp_delete_osc_ses";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}
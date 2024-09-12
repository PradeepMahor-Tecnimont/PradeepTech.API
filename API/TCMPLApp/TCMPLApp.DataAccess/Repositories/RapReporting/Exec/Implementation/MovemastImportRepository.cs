using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.RapReporting;

namespace TCMPLApp.DataAccess.Repositories.RapReporting
{
    public class MovemastImportRepository : ExecTcmPLRepository<ParameterSpTcmPL, MovemastImportOutput>, IMovemastImportRepository
    {

        public MovemastImportRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {

        }        

        public async Task<MovemastImportOutput> ImportMovemastAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.rap_movemast_excel.import_movemast_costcode";            
            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }        
    }
}

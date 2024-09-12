using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public class MovementAssignmentDataTableListRepository : ViewTcmPLRepository<MovementAssignmentDataTableList>, IMovementAssignmentDataTableListRepository
    {
        public MovementAssignmentDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<MovementAssignmentDataTableList>> MovementAssignmentDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dms_movement_qry.fn_movement_assignment_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

    }
}
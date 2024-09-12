using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public class MovementsDataTableListRepository : ViewTcmPLRepository<MovementsDataTableList>, IMovementsDataTableListRepository
    {
        public MovementsDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<MovementsDataTableList>> MovementsDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dms_movement_qry.fn_movement_request_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        //public async Task<IEnumerable<MovementsDataTableList>> MovementsDataTableListExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        //{
        //    CommandText = "dms.pkg_inv_item_types_qry.fn_xl_item_types";
        //    return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        //}
    }
}
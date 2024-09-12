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
    public class MovementsSelectedDeskDataTableListRepository : ViewTcmPLRepository<MovementsSelectedDeskDataTableList>, IMovementsSelectedDeskDataTableListRepository
    {
        public MovementsSelectedDeskDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<MovementsSelectedDeskDataTableList>> MovementsSourceDeskDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dms_movement_qry.fn_selected_source_desk_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<MovementsSelectedDeskDataTableList>> MovementsTargetDeskDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dms_movement_qry.fn_selected_target_desk_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<MovementsSelectedDeskDataTableList>> DeskAssetDetailDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dms_movement_qry.fn_desk_asset_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
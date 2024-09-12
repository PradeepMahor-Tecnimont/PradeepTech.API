using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;

using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.SWP;

namespace TCMPLApp.DataAccess.Repositories.SWP
{
    public class SWPOfficeAtndDataTableListRepository : ViewTcmPLRepository<OfficeAtndDataTableList>, ISWPOfficeAtndDataTableListRepository
    {
        public SWPOfficeAtndDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<OfficeAtndDataTableList>> SmartWorkAreaDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "Select *  From Table (selfservice.iot_swp_qry.fn_area_list_for_smartwork(:p_person_id,:p_meta_id,:p_date,:p_row_number,:p_page_length))";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL, false);
        }

        #region SmartWorkspace

        public async Task<IEnumerable<OfficeAtndDataTableList>> SmartReservedWorkAreaDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_smart_workspace_qry.fn_reserved_area_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<OfficeAtndDataTableList>> SmartGeneralWorkAreaDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_smart_workspace_qry.fn_general_area_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<OfficeAtndDataTableList>> SmartGeneralWorkAreaRestrictedDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_smart_workspace_qry.fn_general_area_restrictedlist";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<OfficeAtndDataTableList>> SmartRestrictedWorkAreaDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "Select *  From Table (selfservice.iot_swp_smart_workspace_qry.fn_restricted_area_list(:p_person_id,:p_meta_id,:p_date,:p_row_number,:p_page_length))";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL, false);
        }

        public async Task<IEnumerable<OfficeAtndDataTableList>> SmartWorkAreaDeskDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_smart_workspace_qry.fn_work_area_desk";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        #endregion SmartWorkspace

        #region OfficeWorkspace

        public async Task<IEnumerable<OfficeAtndDataTableList>> OfficeAtndDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_office_workspace_qry.fn_office_planning";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<OfficeAtndDataTableList>> OfficeGeneralWorkAreaDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_office_workspace_qry.fn_general_area_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<OfficeAtndDataTableList>> OfficeGeneralWorkAreaDeskDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_office_workspace_qry.fn_work_area_desk";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        #endregion OfficeWorkspace
    }
}
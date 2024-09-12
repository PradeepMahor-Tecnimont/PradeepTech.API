using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public class DMSGuestMasterDataTableListRepository : ViewTcmPLRepository<DMSGuestMasterDataTableList>, IDMSGuestMasterDataTableListRepository
    {
        public DMSGuestMasterDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<DMSGuestMasterDataTableList>> GuestMasterDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dms_guest_qry.fn_dm_adm_guests";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<DMSGuestMasterDataTableList>> GuestMasterLogDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dms_guest_qry.fn_dm_adm_guests_log";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<DMSGuestMasterDataTableList>> GuestMasterDataTableListForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dms_guest_qry.fn_xl_dm_adm_guests";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
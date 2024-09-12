using Microsoft.Extensions.Logging;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.DataAccess.Repositories.Timesheet
{
    public class OSCMhrsRepository : ExecTcmPLRepository<ParameterSpTcmPL, DBProcMessageOutput>, IOSCMhrsRepository
    {       
        public OSCMhrsRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {

        }
        public async Task<DBProcMessageOutput> OSCMhrsAddAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.pkg_ts_osc_mhrs.sp_add_osc_mhrs";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }

        public async Task<DBProcMessageOutput> OSCMhrsUpdateAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.pkg_ts_osc_mhrs.sp_update_osc_mhrs_detail";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }

        public async Task<DBProcMessageOutput> OSCMhrsDeleteAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.pkg_ts_osc_mhrs.sp_delete_osc_mhrs_detail";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }

        public async Task<DBProcMessageOutput> OSCMhrsLockAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.pkg_ts_osc_mhrs.sp_lock_osc_mhrs";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }

        public async Task<DBProcMessageOutput> OSCMhrsUnlockAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.pkg_ts_osc_mhrs.sp_unlock_osc_mhrs";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }

        public async Task<DBProcMessageOutput> OSCMhrsApproveAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.pkg_ts_osc_mhrs.sp_hod_approve_osc_mhrs";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }

        public async Task<DBProcMessageOutput> OSCMhrsRevokeApproveAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.pkg_ts_osc_mhrs.sp_hod_disapprove_osc_mhrs";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }

        public async Task<DBProcMessageOutput> OSCMhrsPostAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.pkg_ts_osc_mhrs.sp_post_osc_mhrs";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }

        public async Task<DBProcMessageOutput> OSCMhrsUnPostAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.pkg_ts_osc_mhrs.sp_unpost_osc_mhrs";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }

        public async Task<DBProcMessageOutput> OSCMhrsIsEditableAllowed(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.pkg_ts_osc_mhrs_qry.sp_check_editable_month";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}

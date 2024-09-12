using Microsoft.Extensions.Logging;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.Common;


namespace TCMPLApp.DataAccess.Repositories.Attendance
{


    public class AttendanceEmpCardRFIDUploadRepository : ExecTcmPLRepository<ParameterSpTcmPL, DBProcMessageOutput>, IAttendanceEmpCardRFIDUploadRepository
    {
        public AttendanceEmpCardRFIDUploadRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<DBProcMessageOutput> UploadEmpCardRFIDDataAsync(
            BaseSpTcmPL baseSpTcmPL,
            ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.emp_card_rfid.import_card_rfid";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            //var tags = new string[] {
            //    $"USER/{ baseSpTcmPL.UIUserId }"
            //};
            //await _redisContext.Cache.InvalidateKeysByTagAsync(tags);

            return response;
        }


    }
}

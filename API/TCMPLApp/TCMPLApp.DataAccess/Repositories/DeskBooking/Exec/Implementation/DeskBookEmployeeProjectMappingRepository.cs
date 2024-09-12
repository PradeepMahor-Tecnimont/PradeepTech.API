using DocumentFormat.OpenXml.Spreadsheet;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.DataAccess.Repositories.DeskBooking
{
    public class DeskBookEmployeeProjectMappingRepository : ExecTcmPLRepository<ParameterSpTcmPL, DBProcMessageOutput>, IDeskBookEmployeeProjectMappingRepository
    {
        public DeskBookEmployeeProjectMappingRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<DBProcMessageOutput> EmployeeProjectCreateAsync(BaseSpTcmPL baseSpTcmPL,ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "desk_book.pkg_db_emp_proj_map.sp_add_emp_proj";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }

        public async Task<DBProcMessageOutput> EmployeeProjectEditAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "desk_book.pkg_db_emp_proj_map.sp_update_emp_proj";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }

        public async Task<DBProcMessageOutput> EmployeeProjectDeleteAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "desk_book.pkg_db_emp_proj_map.sp_delete_emp_proj";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}

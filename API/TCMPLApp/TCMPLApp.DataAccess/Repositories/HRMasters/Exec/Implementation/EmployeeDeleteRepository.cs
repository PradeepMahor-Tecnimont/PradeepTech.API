using DocumentFormat.OpenXml.Spreadsheet;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.ERS;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.Common;
using TCMPLApp.Domain.Models.HRMasters;

namespace TCMPLApp.DataAccess.Repositories.HRMasters
{
    public class EmployeeDeleteRepository : ExecTcmPLRepository<ParameterSpTcmPL, DBProcMessageOutput>, IEmployeeDeleteRepository
    {

        public EmployeeDeleteRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }
        
        public async Task<DBProcMessageOutput> EmployeeDeleteRequestCreate(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.hr_pkg_emplmast_delete.sp_delete_employee_request";
            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);
            return response;
        }

        public async Task<DBProcMessageOutput> EmployeeDeleteRequestApproval(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.hr_pkg_emplmast_delete.sp_delete_employee_approval";
            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);
            return response;
        }
        public async Task<DBProcMessageOutput> EmployeeDeleteRequestDelete(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.hr_pkg_emplmast_delete.sp_delete_employee_request_delete";
            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);
            return response;
        }

    }
}

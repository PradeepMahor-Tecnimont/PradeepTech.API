using DocumentFormat.OpenXml.Spreadsheet;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Attendance;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.Attendance;
using TCMPLApp.Domain.Models.HRMasters;

namespace TCMPLApp.DataAccess.Repositories.HRMasters
{
    public class EmpOfficeLocationImportRepository : ExecTcmPLRepository<ParameterSpTcmPL, EmpOfficeLocationOutPut>, IEmpOfficeLocationImportRepository
    {
        public EmpOfficeLocationImportRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<EmpOfficeLocationOutPut> ImportEmpOfficeLocationAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.eo_employee_office.sp_import_emp_office_location_json";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;

        }
    }
}

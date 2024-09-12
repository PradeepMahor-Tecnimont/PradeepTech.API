using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.HRMasters;

namespace TCMPLApp.DataAccess.Repositories.HRMasters
{
    public class EmpOfficeLocationDetailRepository : ExecTcmPLRepository<ParameterSpTcmPL, EmpOfficeDetails>, IEmpOfficeLocationDetailRepository
    {
        public EmpOfficeLocationDetailRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<EmpOfficeDetails> EmpOfficeLocationDetail(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.eo_employee_office.sp_details";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}

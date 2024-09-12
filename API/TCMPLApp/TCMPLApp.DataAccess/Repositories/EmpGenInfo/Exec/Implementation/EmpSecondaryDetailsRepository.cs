using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;

using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.EmpGenInfo;

namespace TCMPLApp.DataAccess.Repositories.EmpGenInfo
{
    public class EmpSecondaryDetailsRepository : ExecTcmPLRepository<ParameterSpTcmPL, EmpSecondaryDetailOut>, IEmpSecondaryDetailsRepository
    {
        public EmpSecondaryDetailsRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<EmpSecondaryDetailOut> EmpSecondaryDetailsAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_emp_details.sp_emp_secondary_detail";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }

        public async Task<EmpSecondaryDetailOut> HREmpSecondaryDetailsAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_emp_details.sp_4hr_emp_secondary_detail";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }

    }
}
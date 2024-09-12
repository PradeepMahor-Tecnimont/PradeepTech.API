using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models;

namespace TCMPLApp.DataAccess.Repositories.EmpGenInfo
{
    public class EmpRelativesDeclStatusDetailsRepository : ExecTcmPLRepository<ParameterSpTcmPL, EmpRelativesDeclStatusDetailOut>, IEmpRelativesDeclStatusDetailsRepository
    {
        public EmpRelativesDeclStatusDetailsRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<EmpRelativesDeclStatusDetailOut> EmpRelativesDeclStatusDetailsAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_relatives_as_colleagues_qry.sp_emp_relatives_decl_status_details";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}

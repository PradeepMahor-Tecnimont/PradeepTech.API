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

namespace TCMPLApp.DataAccess.Repositories.EmpGenInfo
{
    public class EmploymentOfficeRelativesRepository : ExecTcmPLRepository<ParameterSpTcmPL, DBProcMessageOutput>, IEmploymentOfficeRelativesRepository
    {
        public EmploymentOfficeRelativesRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<DBProcMessageOutput> EmploymentOfficeRelativesAddAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_relatives_as_colleagues.sp_add_emp_relatives_as_colleagues";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}

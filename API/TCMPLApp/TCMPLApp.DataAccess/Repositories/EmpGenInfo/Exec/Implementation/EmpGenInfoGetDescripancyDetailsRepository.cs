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
    public class EmpGenInfoGetDescripancyDetailsRepository : ExecTcmPLRepository<ParameterSpTcmPL, EmpGenInfoGetDescripancyDetailOut>, IEmpGenInfoGetDescripancyDetailsRepository
    {
        public EmpGenInfoGetDescripancyDetailsRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<EmpGenInfoGetDescripancyDetailOut> EmpGenInfoGetDescripancyDetailsAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.emp_gen_info_validate.get_descripancy";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}
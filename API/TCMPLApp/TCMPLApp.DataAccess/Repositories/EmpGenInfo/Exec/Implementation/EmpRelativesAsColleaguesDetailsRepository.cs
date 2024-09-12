using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using Microsoft.Extensions.Logging;
using TCMPLApp.Domain.Models;

namespace TCMPLApp.DataAccess.Repositories.EmpGenInfo
{
    public class EmpRelativesAsColleaguesDetailsRepository : ExecTcmPLRepository<ParameterSpTcmPL, EmpRelativesAsColleaguesDetailOut>, IEmpRelativesAsColleaguesDetailsRepository
    {
        public EmpRelativesAsColleaguesDetailsRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<EmpRelativesAsColleaguesDetailOut> EmpRelativesAsColleaguesDetailsAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_relatives_as_colleagues_qry.sp_emp_relatives_widget";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}

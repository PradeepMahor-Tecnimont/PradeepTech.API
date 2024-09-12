using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.ERS;

namespace TCMPLApp.DataAccess.Repositories.ERS
{
    public class HRCVReferEmpDetailRepository : ExecTcmPLRepository<ParameterSpTcmPL, HRCVReferEmpDetailOutput>, IHRCVReferEmpDetailRepository
    {

        public HRCVReferEmpDetailRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }       

        public async Task<HRCVReferEmpDetailOutput> CVReferEmpDetail(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.ers_hr_qry.sp_hr_cv_refer_emp_detail";
            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);
            return response;
        }
    }
}

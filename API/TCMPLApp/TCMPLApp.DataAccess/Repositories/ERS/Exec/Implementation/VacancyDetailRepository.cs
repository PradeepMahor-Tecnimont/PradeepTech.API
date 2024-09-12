using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.ERS;

namespace TCMPLApp.DataAccess.Repositories.ERS
{
    public class VacancyDetailRepository : ExecTcmPLRepository<ParameterSpTcmPL, VacancyDetailOut>, IVacancyDetailRepository
    {

        public VacancyDetailRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        #region Vacancy Detail   

        public async Task<VacancyDetailOut> VacancyDetail(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.ers_qry.sp_vacancy_detail";
            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);
            return response;
        }

        #endregion Vacancy Detail

    }
}

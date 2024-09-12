using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.ERS;

namespace TCMPLApp.DataAccess.Repositories.ERS
{
    public interface IHRVacancyDetailRepository
    {
        #region Vacancy Detail
        public Task<HRVacancyDetailOut> VacancyDetail(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

    #endregion Vacancy Detail

    }
}

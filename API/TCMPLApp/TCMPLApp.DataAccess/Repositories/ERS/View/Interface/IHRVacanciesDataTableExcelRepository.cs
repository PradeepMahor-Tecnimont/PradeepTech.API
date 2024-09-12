using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.ERS;

namespace TCMPLApp.DataAccess.Repositories.ERS
{
    public interface IHRVacanciesDataTableExcelRepository
    {
        public Task<IEnumerable<HRVacanciesDataTableExcel>> VacanciesDataTableExcel(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        
    }
}

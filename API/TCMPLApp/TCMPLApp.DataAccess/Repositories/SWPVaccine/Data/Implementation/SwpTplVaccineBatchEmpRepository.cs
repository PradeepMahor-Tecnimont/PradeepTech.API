using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.SWPVaccine;

namespace TCMPLApp.DataAccess.Repositories.SWPVaccine
{
    public class SwpTplVaccineBatchEmpRepository : DataAccess.Base.DataRepository<SwpTplVaccineBatchEmp>, ISwpTplVaccineBatchEmpRepository
    {
        public SwpTplVaccineBatchEmpRepository(DataContext dataContext) : base(dataContext)
        {

        }
    }
}

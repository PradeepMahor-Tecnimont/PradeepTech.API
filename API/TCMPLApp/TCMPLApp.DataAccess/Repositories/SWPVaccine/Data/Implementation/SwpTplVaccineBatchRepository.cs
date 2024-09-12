using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.SWPVaccine;

namespace TCMPLApp.DataAccess.Repositories.SWPVaccine
{
    public class SwpTplVaccineBatchRepository : DataAccess.Base.DataRepository<SwpTplVaccineBatch>, ISwpTplVaccineBatchRepository
    {
        public SwpTplVaccineBatchRepository(DataContext dataContext) : base(dataContext)
        {

        }
    }
}

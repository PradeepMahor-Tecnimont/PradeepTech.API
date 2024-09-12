using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.SWPVaccine;

namespace TCMPLApp.DataAccess.Repositories.SWPVaccine
{
    public class SwpTplVaccineBatchDetailsRepository : DataAccess.Base.DataRepository<SwpVuTplVaccineBatchDet>, ISwpTplVaccineBatchDetailsRepository
    {
        public SwpTplVaccineBatchDetailsRepository(DataContext dataContext) : base(dataContext)
        {

        }
    }
}

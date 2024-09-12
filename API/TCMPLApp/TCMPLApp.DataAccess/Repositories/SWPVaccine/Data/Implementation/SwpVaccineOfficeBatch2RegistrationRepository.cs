using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.SWPVaccine;
namespace TCMPLApp.DataAccess.Repositories.SWPVaccine
{
    public class SwpVaccineOfficeBatch2RegistrationRepository : DataAccess.Base.DataRepository<SwpVuVaccineOffBatch2Regn>, ISwpVaccineOfficeBatch2RegistrationRepository
    {
        public SwpVaccineOfficeBatch2RegistrationRepository(DataContext dataContext) : base(dataContext)
        {

        }
    }
}

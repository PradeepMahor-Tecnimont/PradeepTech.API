using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models;
using TCMPLApp.Domain.Models.SWPVaccine;

namespace TCMPLApp.DataAccess.Repositories.SWPVaccine
{
    public class SwpRelationMastRepository : DataAccess.Base.DataRepository<SwpRelationMast>, ISwpRelationMastRepository
    {
        public SwpRelationMastRepository(DataContext dataContext) : base(dataContext)
        {

        }
    }
}

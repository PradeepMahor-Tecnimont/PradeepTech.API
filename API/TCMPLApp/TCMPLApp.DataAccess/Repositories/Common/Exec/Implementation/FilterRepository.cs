using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models;

using System.Dynamic;

namespace TCMPLApp.DataAccess.Repositories.Common
{
    public class FilterRepository : ExecRepository, IFilterRepository
    {

        public FilterRepository(ExecDBContext execDBContext) : base(execDBContext)
        {

        }

        public async Task<FilterCreate> FilterCreateAsync(FilterCreate filterCreate )
        {
            return await ExecuteProcAsync(filterCreate);
        }


        public async Task<FilterRetrieve> FilterRetrieveAsync(FilterRetrieve filterRetrieve)
        {
            return await ExecuteProcAsync(filterRetrieve);

        }

        public async Task<FilterReset> FilterResetAsync(FilterReset filterReset)
        {
            return await ExecuteProcAsync(filterReset);

        }

    }
}

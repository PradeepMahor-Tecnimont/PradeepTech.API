using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models;
using TCMPLApp.Domain.Models.Attendance;

namespace TCMPLApp.DataAccess.Repositories.Common
{


    public interface IFilterRepository 
    {
        public Task<FilterCreate> FilterCreateAsync(FilterCreate  filterCreate);

        public Task<FilterRetrieve> FilterRetrieveAsync(FilterRetrieve filterRetrieve);

        public  Task<FilterReset> FilterResetAsync(FilterReset filterReset);

    }
}

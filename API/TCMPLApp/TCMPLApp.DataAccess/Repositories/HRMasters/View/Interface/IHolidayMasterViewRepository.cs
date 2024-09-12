using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.HRMasters;

namespace TCMPLApp.DataAccess.Repositories.HRMasters
{
    public interface IHolidayMasterViewRepository
    {
        #region H O L I D A Y   M A S T E R

        public Task<int?> GetHolidayCount();

        public Task<IEnumerable<HolidayMaster>> GetHolidayMasterListAsync();

        public Task<HolidayMaster> HolidayDetail(int id);        

        #endregion H O L I D A Y   M A S T E R
    }
}

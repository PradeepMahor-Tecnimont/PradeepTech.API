using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.HRMasters;

namespace TCMPLApp.DataAccess.Repositories.HRMasters
{
    public class HolidayMasterViewRepository : Base.ExecRepository, IHolidayMasterViewRepository
    {       
        public HolidayMasterViewRepository(Domain.Context.ExecDBContext execDBContext) : base(execDBContext)
        {

        }

        #region H O L I D A Y   M A S T E R

        public async Task<int?> GetHolidayCount()
        {
            return (await QueryAsync<int>(HRMastersQueries.HolidayMasterListCount)).FirstOrDefault();
        }

        public async Task<IEnumerable<HolidayMaster>> GetHolidayMasterListAsync()
        {
            return await QueryAsync<HolidayMaster>(HRMastersQueries.HolidayMasterList);
        }
        public async Task<HolidayMaster> HolidayDetail(int id)
        {
            return await QueryFirstOrDefaultAsync<HolidayMaster>(HRMastersQueries.HolidayDeatil, new { pSrno = id });
        }        

        #endregion H O L I D A Y   M A S T E R
    }
}

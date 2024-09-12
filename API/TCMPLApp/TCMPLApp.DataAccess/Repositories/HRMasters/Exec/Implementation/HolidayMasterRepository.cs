using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.HRMasters;

namespace TCMPLApp.DataAccess.Repositories.HRMasters
{
    public class HolidayMasterRepository : Base.ExecRepository, IHolidayMasterRepository
    {       
        public HolidayMasterRepository(Domain.Context.ExecDBContext execDBContext) : base(execDBContext)
        {

        }

        #region H O L I D A Y   M A S T E R

        public async Task<HolidayMasterAdd> AddHoliday(HolidayMasterAdd holidayMasterAdd)
        {
            return await ExecuteProcAsync(holidayMasterAdd);
        }

        public async Task<HolidayMasterUpdate> UpdateHoliday(HolidayMasterUpdate holidaymasterUpdate)
        {
            return await ExecuteProcAsync(holidaymasterUpdate);
        }

        public async Task<HolidayDelete> DeleteHoliday(HolidayDelete holidayDelete)
        {
            return await ExecuteProcAsync(holidayDelete);
        }

        public async Task<WeekendHoliday> PopulateWeekendHoliday(WeekendHoliday weekendHoliday)
        {
            return await ExecuteProcAsync(weekendHoliday);
        }

        #endregion H O L I D A Y   M A S T E R
    }
}

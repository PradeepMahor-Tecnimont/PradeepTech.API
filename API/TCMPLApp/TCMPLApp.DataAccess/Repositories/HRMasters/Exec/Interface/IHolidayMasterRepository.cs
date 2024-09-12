using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.HRMasters;

namespace TCMPLApp.DataAccess.Repositories.HRMasters
{
    public interface IHolidayMasterRepository
    {
        #region H O L I D A Y   M A S T E R
        
        public Task<HolidayMasterAdd> AddHoliday(HolidayMasterAdd holidayMasterAdd);

        public Task<HolidayMasterUpdate> UpdateHoliday(HolidayMasterUpdate holidayMasterUpdate);

        public Task<HolidayDelete> DeleteHoliday(HolidayDelete holidayDelete);

        public Task<WeekendHoliday> PopulateWeekendHoliday(WeekendHoliday weekendHoliday);

        #endregion H O L I D A Y   M A S T E R
    }
}

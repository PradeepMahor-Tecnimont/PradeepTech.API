using System.Collections.Generic;
using TCMPLApp.Domain.Models.DeskBooking;

namespace TCMPLApp.WebApp.Models
{
    public class DeskBookingIndexViewModel
    {
        public DeskBookingIndexViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }

        public FilterDataModel FilterDataModel { get; set; }

        public IEnumerable<DeskBookingDataTableList> deskBookingDataTableLists { get; set; }
    }
}